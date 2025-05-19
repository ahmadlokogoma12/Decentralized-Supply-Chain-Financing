# Decentralized Supply Chain Financing

A blockchain-based system for supply chain financing using Clarity smart contracts. This system enables suppliers to receive early payments on their invoices at a discount, while providing funders with opportunities to earn returns by providing liquidity.

## Overview

Supply chain financing is a critical component of global trade, allowing suppliers to receive payments earlier than the invoice due date, typically at a discount. This decentralized system leverages blockchain technology to create a transparent, efficient, and trustless platform for supply chain financing.

Key benefits:
- **Transparency**: All transactions and verifications are recorded on the blockchain
- **Efficiency**: Automated processes reduce paperwork and administrative overhead
- **Trust**: Cryptographic verification eliminates the need for trusted intermediaries
- **Accessibility**: Open platform allows participation from diverse funding sources
- **Risk Management**: Built-in credit assessment and supplier verification

## System Components

### Supplier Verification Contract
Validates legitimate vendors in the supply chain ecosystem.

**Key Features:**
- Supplier registration and verification
- Supplier status management (active/inactive)
- Verification data storage and retrieval

### Invoice Verification Contract
Records and authenticates billing documents in the supply chain.

**Key Features:**
- Invoice registration with details (amount, due date, etc.)
- Invoice status tracking (pending, paid, overdue)
- Secure invoice data storage and retrieval

### Early Payment Contract
Manages discounted accelerated settlements for suppliers.

**Key Features:**
- Early payment requests with discount specification
- Approval workflow for early payment requests
- Payment tracking and status updates

### Credit Risk Assessment Contract
Tracks payment history and reliability of entities in the system.

**Key Features:**
- Credit profile management for suppliers and buyers
- Payment event recording (on-time, late, default)
- Credit score calculation based on payment history

### Funding Pool Contract
Manages liquidity for supply chain financing operations.

**Key Features:**
- Fund contribution management
- Fund allocation for early payments
- Withdrawal mechanisms for funders

## Getting Started

### Prerequisites
- Clarity development environment
- Stacks blockchain node (for deployment)
- Vitest (for running tests)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/decentralized-supply-chain-financing.git
   cd decentralized-supply-chain-financing
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Deploy the contracts to the Stacks blockchain:
   ```bash
   # Using Clarinet or other Stacks deployment tools
   clarinet deploy
   ```

## Usage

### For Suppliers

1. **Get Verified**:
    - Submit company information for verification
    - Once verified, you can participate in the system

2. **Register Invoices**:
    - Register your invoices with buyer information, amount, and due date
    - Invoices are verified and recorded on the blockchain

3. **Request Early Payment**:
    - Select an invoice and specify a discount percentage
    - Submit early payment request
    - Receive payment once approved

### For Funders

1. **Add Funds to Pool**:
    - Contribute funds to the financing pool
    - Funds are tracked and proportional ownership is maintained

2. **Monitor Allocations**:
    - Track how your funds are being used for early payments
    - View returns from discount rates

3. **Withdraw Contributions**:
    - Withdraw your proportional share of the pool when desired

### For Administrators

1. **Verify Suppliers and Invoices**:
    - Review and approve supplier verification requests
    - Validate invoice authenticity

2. **Approve Early Payment Requests**:
    - Review and approve early payment requests
    - Allocate funds for approved requests

3. **Manage Credit Risk**:
    - Record payment events (on-time, late, default)
    - Monitor credit scores of participants

## Contract Details

### Supplier Verification Contract
```clarity
;; supplier-verification.clar
;; This contract validates legitimate vendors in the supply chain

(define-data-var admin principal tx-sender)

;; Map to store verified suppliers
(define-map verified-suppliers principal
  {
    company-name: (string-utf8 100),
    registration-number: (string-utf8 50),
    verification-date: uint,
    is-active: bool
  }
)
```

### Invoice Verification Contract
```clarity
;; invoice-verification.clar
;; This contract records authenticated billing documents

(define-data-var admin principal tx-sender)

;; Map to store verified invoices
(define-map verified-invoices (tuple (invoice-id (string-utf8 50)) (supplier principal))
  {
    buyer: principal,
    amount: uint,
    due-date: uint,
    verification-date: uint,
    status: (string-utf8 20) ;; "pending", "paid", "overdue"
  }
)
```

### Early Payment Contract
```clarity
;; early-payment.clar
;; This contract manages discounted accelerated settlements

(define-data-var admin principal tx-sender)

;; Map to store early payment requests
(define-map early-payment-requests (tuple (invoice-id (string-utf8 50)) (supplier principal))
  {
    original-amount: uint,
    discounted-amount: uint,
    requested-date: uint,
    status: (string-utf8 20), ;; "pending", "approved", "rejected", "paid"
    payment-date: (optional uint)
  }
)
```

### Credit Risk Assessment Contract
```clarity
;; credit-risk-assessment.clar
;; This contract tracks payment history and reliability

(define-data-var admin principal tx-sender)

;; Map to store entity credit profiles
(define-map credit-profiles principal
  {
    total-transactions: uint,
    on-time-payments: uint,
    late-payments: uint,
    default-count: uint,
    last-updated: uint,
    credit-score: uint  ;; 0-1000 scale
  }
)
```

### Funding Pool Contract
```clarity
;; funding-pool.clar
;; This contract manages liquidity for supply chain financing

(define-data-var admin principal tx-sender)
(define-data-var total-funds uint u0)
(define-data-var active bool true)

;; Map to track funder contributions
(define-map funder-contributions principal uint)

;; Map to track allocated funds
(define-map allocated-funds (tuple (invoice-id (string-utf8 50)) (supplier principal)) uint)
```

## Testing

Run the tests using Vitest:

```bash
npm run test
```

The test suite includes comprehensive tests for all contracts:
- Supplier verification functionality
- Invoice registration and status updates
- Early payment request workflow
- Credit risk assessment and scoring
- Funding pool operations

## System Architecture

```mermaid title="System Architecture" type="diagram"
graph TD;
    A["Supplier"] -->|"Registers"| B["Supplier Verification Contract"]
    A -->|"Submits"| C["Invoice Verification Contract"]
    A -->|"Requests"| D["Early Payment Contract"]
    E["Funder"] -->|"Contributes to"| F["Funding Pool Contract"]
    G["Admin"] -->|"Verifies"| B
    G -->|"Approves"| C
    G -->|"Approves"| D
    G -->|"Records Payment Events"| H["Credit Risk Assessment Contract"]
    D -->|"Requests Funds"| F
    F -->|"Allocates Funds"| D
    H -->|"Provides Risk Data"| D
