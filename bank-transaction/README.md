The basic specifications
- The database will store transactions against a user and currency
- Every user has one balance per currency, so each balance is simply the sum of all transactions against a given user and currency
- A balance cannot be negative
- guarantee that a balance never contradicts its transaction history

# Implementation Options
## Two tables Transaction and Balance. 
Several options to sync two tables.
- TRANSACTION procedure update two tables in sync
- Apply transaction to table `transaction` and have a trigger to update `balance` table

## Table Transaction and Balance indexed view
Balance indexed view aggregate transactions.
### Cons:
- Unable to enforce non-negative balance

## A single table Transaction with balance column
The latest transaction record for a user and currency contains their balance.

### Cons:
- When inserting a transaction out of sequence (ie: to correct an issue/incorrect starting balance), you may need to cascade updates for all subsequent transactions. 

## Transaction table, balance indexed view and Account Statement for Autdit
The balance of a specific account is:
- `AccountStatement.ClosingBalance` of the previous month.
- Plus the SUM of `AccountTransaction.Amount` in the current month, where `TransactionType` indicates a deposit.
- Minus the SUM of `AccountTransaction.Amount` in the current month, where `TransactionType` indicates a withdrawal.