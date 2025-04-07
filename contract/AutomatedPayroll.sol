// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AutomatedPayroll {
    
    // Ownable implementation
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // ReentrancyGuard implementation
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;
    uint256 private status;

    modifier nonReentrant() {
        require(status != ENTERED, "ReentrancyGuard: reentrant call");
        status = ENTERED;
        _;
        status = NOT_ENTERED;
    }

    constructor() {
        owner = msg.sender;
        status = NOT_ENTERED;
    }

    struct Employee {
        address walletAddress;
        uint256 salary;
        uint256 paymentInterval; // in seconds (e.g. 2592000 = monthly)
        uint256 lastPaymentTime;
        uint256 remainingBalance;
        bool exists;
    }

    mapping(address => Employee) public employees;
    address[] public employeeList;

    event EmployeeAdded(address indexed employeeAddress, uint256 salary);
    event EmployeeRemoved(address indexed employeeAddress);
    event SalaryUpdated(address indexed employeeAddress, uint256 newSalary);
    event PaymentProcessed(address indexed employeeAddress, uint256 amount);
    event DepositReceived(address indexed from, uint256 amount);
    event Withdrawal(address indexed employee, uint256 amount);

    // Add a new employee
    function addEmployee(
        address _employeeAddress,
        uint256 _salary,
        uint256 _paymentInterval
    ) external onlyOwner {
        require(!employees[_employeeAddress].exists, "Employee already exists");

        employees[_employeeAddress] = Employee({
            walletAddress: _employeeAddress,
            salary: _salary,
            paymentInterval: _paymentInterval,
            lastPaymentTime: block.timestamp,
            remainingBalance: 0,
            exists: true
        });

        employeeList.push(_employeeAddress);
        emit EmployeeAdded(_employeeAddress, _salary);
    }

    // Remove an employee
    function removeEmployee(address _employeeAddress) external onlyOwner {
        require(employees[_employeeAddress].exists, "Employee does not exist");

        uint256 balance = employees[_employeeAddress].remainingBalance;
        if (balance > 0) {
            _safeTransfer(_employeeAddress, balance);
        }

        delete employees[_employeeAddress];
        _removeAddressFromList(_employeeAddress);
        emit EmployeeRemoved(_employeeAddress);
    }

    // Update employee salary
    function updateSalary(address _employeeAddress, uint256 _newSalary) external onlyOwner {
        require(employees[_employeeAddress].exists, "Employee does not exist");
        employees[_employeeAddress].salary = _newSalary;
        emit SalaryUpdated(_employeeAddress, _newSalary);
    }

    // Process employee payment
    function processPayment(address _employeeAddress) external onlyOwner nonReentrant {
        Employee storage employee = employees[_employeeAddress];
        require(employee.exists, "Employee does not exist");

        uint256 intervalsElapsed = (block.timestamp - employee.lastPaymentTime) / employee.paymentInterval;
        require(intervalsElapsed > 0, "Payment interval not reached");

        uint256 paymentAmount = employee.salary * intervalsElapsed;
        require(address(this).balance >= paymentAmount, "Insufficient contract balance");

        employee.remainingBalance += paymentAmount;
        employee.lastPaymentTime += (intervalsElapsed * employee.paymentInterval);

        emit PaymentProcessed(_employeeAddress, paymentAmount);
    }

    // Withdraw salary by employee
    function withdraw() external nonReentrant {
        Employee storage employee = employees[msg.sender];
        require(employee.exists, "Not an employee");
        require(employee.remainingBalance > 0, "No balance to withdraw");

        uint256 amount = employee.remainingBalance;
        employee.remainingBalance = 0;
        _safeTransfer(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);
    }

    // Deposit funds by owner
    function deposit() external payable onlyOwner {
        emit DepositReceived(msg.sender, msg.value);
    }

    // View contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Internal transfer using call
    function _safeTransfer(address recipient, uint256 amount) internal {
        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Helper: remove employee from list
    function _removeAddressFromList(address _employeeAddress) internal {
        for (uint256 i = 0; i < employeeList.length; i++) {
            if (employeeList[i] == _employeeAddress) {
                employeeList[i] = employeeList[employeeList.length - 1];
                employeeList.pop();
                break;
            }
        }
    }

    // Accept direct ETH
    receive() external payable {
        emit DepositReceived(msg.sender, msg.value);
    }
}
