# Automated Payroll System using Smart Contracts

## Overview

A decentralized payroll system built on the Ethereum blockchain that enables employers to automate salary disbursements and allows employees to withdraw their earnings directly. The system ensures transparency, reduces manual errors, and improves trust between employers and employees using smart contract technology.

---

## Project Vision

To create a transparent, secure, and decentralized payroll system that eliminates intermediaries, reduces fraud, and empowers employees with real-time access to their salaries through the blockchain.

---

## Features

- **Admin-Controlled Employee Management**
  - Add, update, or remove employee records.
  
- **Automated Salary Calculation**
  - Salary is calculated based on defined time intervals.
  
- **Secure Salary Withdrawal**
  - Employees can withdraw their accumulated salary anytime.
  
- **On-Chain Recordkeeping**
  - All salary events are stored and can be tracked via blockchain logs.
  
- **Reentrancy Guard**
  - Protects the contract from reentrancy attacks during transactions.

- **Direct ETH Support**
  - Supports ETH payments via the `deposit()` function or direct transfer to the contract.

---

## Smart Contract Structure

- `addEmployee()`: Adds a new employee with salary and payment interval.
- `removeEmployee()`: Removes an employee and pays out any remaining balance.
- `updateSalary()`: Updates the salary of an existing employee.
- `processPayment()`: Adds due salary to employee balance based on intervals.
- `withdraw()`: Allows employees to withdraw their available balance.
- `deposit()`: Owner can deposit ETH into the contract to fund salaries.

---

## Technologies Used

- **Solidity** – For smart contract development
- **Ethereum Virtual Machine (EVM)**
- **MetaMask / Remix IDE** – For testing and deployment
- **JavaScript (optional)** – For frontend integration (planned)

---

## Deployment Instructions

1. Open the contract in [Remix IDE](https://remix.ethereum.org).
2. Compile the contract using Solidity 0.8.0 or higher.
3. Deploy it to a testnet (e.g., Sepolia, Goerli) using MetaMask.
4. Use the deployed functions to add employees, process payments, and test withdrawals.

---

## Future Scope

- Integration with **Chainlink Keepers** for automated salary distribution.
- Enable **stablecoin (ERC-20) payments**.
- Build a **frontend dashboard** for employers and employees.
- Role-based access (e.g., HR, Finance teams).
- Multi-chain compatibility (e.g., Polygon, BNB Chain).
- Integration with KYC protocols and analytics dashboards.

---

## License

This project is licensed under the MIT License.

---


## Contact

**Developer:** Abhi Shah  
**Email:** abhishah9784@gmail.com  
**LinkedIn:** [Abhi Shah](https://www.linkedin.com/in/abhi-shah-8077412b5)  
**GitHub:** [abhishah9784](https://github.com/abhishah9784)

## Contract Details: 0xd10B9d237de3c77B8f98fef673AFF99cD3e56c77
![image](https://github.com/user-attachments/assets/7ead5d10-35a7-4bfe-8e21-91134ffb5877)

