//Private loan affordability
/*
In this example, we need to check if the client is able to afford a private loan.
The client does not want to disclose some of their financial information to their solicitor
because they wish to keep that private. The solicitor is willing to accept a Zero Knowledge Proof
that the client is eligible for the loan. 

The necessary private attributes are: 
- Client net income 
- Client existing outgoing expenses 
- Requested loan amount 
- Loan term 
- Guarantor income 
- Guarantor outgoing expenses 

The public attributes are: 
- Current interest rate 
- maximum debt to income ratio 
- minimum income 
- required reserve 

PLEASE NOTE: This is not intended to be an actual ZKP circuit for use in check loan eligibility. This is just an example that I am using to
learn how to use ZKP circuits. 
*/

fn main(client_income : u64,
 client_non_debt_expenses : u64,
 client_debt_expenses : u64,
  loan_amount : u64,
   loan_term : u64,
    guarantor_income : u64,
     guarantor_expenses : u64,
    interest_rate : pub u64,
     maximum_debt_to_income_ratio : pub u64,
      minimum_income : pub u64,
       required_reserve : pub u64) {
        let monthly_interest_rate = (interest_rate / (100*12));
        let loan_months = loan_term * 12;
        let disposable_income = client_income - client_non_debt_expenses - client_debt_expenses;
        let guarantor_dispoable_income = guarantor_income - guarantor_expenses;
        let monthly_repayment = loan_amount * monthly_interest_rate * ( loan_months / 4) ;
        assert(client_income >= minimum_income);
        assert(guarantor_income >= minimum_income);
        assert(disposable_income >= (monthly_repayment + required_reserve));
        assert(100 * client_debt_expenses <= maximum_debt_to_income_ratio * client_income);
        assert(guarantor_dispoable_income >= (monthly_repayment + required_reserve) );
}

// Valid case 
#[test]
fn test_valid() {
    main(3000, 2000, 300, 10000, 48, 4000, 3000, 3, 36, 2000, 500);
}

// Boundary cases
#[test]
fn test_boundary_remaining_client_income() {
    main(4000, 0, 0, 0, 0, 4000, 0, 0, 0, 4000, 0);
}

#[test(should_fail)]
fn test_boundary_fail_remaining_client_income() {
    main(3999, 0, 0, 0, 0, 4000, 0, 0, 0, 4000, 0);
}

#[test]
fn test_boundary_remaining_guarantor_income() {
    main(4000, 0, 0, 0, 0, 4000, 0, 0, 0, 4000, 0);
}

#[test(should_fail)]
fn test_boundary_fail_remaining_guarantor_income() {
    main(3999, 0, 0, 0, 0, 3999, 0, 0, 0, 4000, 0);
}

#[test]
fn test_boundary_client_disposable_income() {
    main(2000, 1200, 0, 100, 1, 4000, 0, 1200, 1, 1000, 500);
}

#[test(should_fail)]
fn test_boundary_fail_client_disposable_income() {
    main(2000, 1200, 0, 100, 1, 4000, 0, 1200, 1, 1000, 501);
}

#[test]
fn test_boundary_guarantor_disposable_income() {
    main(4000, 1200, 0, 100, 1, 2000, 1200, 1200, 1, 1000, 500);
}

#[test(should_fail)]
fn test_boundary_fail_guarantor_disposable_income() {
    main(4000, 1200, 0, 100, 1, 2000, 1200, 1200, 1, 1000, 501);
}

#[test]
fn test_boundary_debt_to_income_ratio() {
    main(3000, 0, 1080, 0, 0, 4000, 0, 0, 36, 2000, 0);
}

#[test(should_fail)]
fn test_boundary_fail_debt_to_income_ratio() {
    main(3000, 0, 1081, 0, 0, 4000, 0, 0, 36, 2000, 0);
}

