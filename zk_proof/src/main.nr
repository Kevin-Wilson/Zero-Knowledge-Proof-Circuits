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
        let monthly_repayment = loan_amount * (( monthly_interest_rate * ((1 + monthly_interest_rate) ** loan_months)) / 
                                ((1 + monthly_interest_rate) ** loan_months) - monthly_interest_rate);
        assert(client_income >= minimum_income);
        assert(guarantor_income >= minimum_income);
        assert(disposable_income >= (monthly_repayment + required_reserve));
        assert((client_debt_expenses / client_income) <= maximum_debt_to_income_ratio);
        assert(guarantor_dispoable_income >= (monthly_repayment + required_reserve) );
}

#[test]
fn test_main() {
    main(3000, 2000, 300, 10000, 48, 4000, 3000, 3, 2, 2000, 500);
    //main(1, 2);
}
