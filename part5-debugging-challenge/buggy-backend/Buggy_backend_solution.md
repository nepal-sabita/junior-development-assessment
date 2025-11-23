# BUG FIXES

## Bug[1]: Non-thread-safe operation on shared mutable state

1. We are using parallelStream(), which means multiple threads execute this line at the same time  and if these are not synched then we can see that some updates get lost and incorrect values is shown
2. So to solve it synchronized() is used to fix the issue which means only one thread can enter the block which make sure the unit is synchronized with no wrong data

## BUG [2]: Failed status set but never persisted to database

1. Whever the status is failed it is not beigng saved in database

2.   paymentRepository.update(payment) used to save it in the database