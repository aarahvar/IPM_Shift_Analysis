function dydt = odefcn(y,tau,prod_term)

dydt = 1/tau*(prod_term-y);
