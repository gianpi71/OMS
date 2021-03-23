clear all; close all; clc;

params.symbol = 'I';
params.securityExchange = 'ICE-LIFFE';
params.maturityMonthYear = '202612';
params.executor = 'U370176';
params.investor = 'U370176';
params.secretKey = '93367bc1-8a0d-4f46-910f-48e2d06a9862';
params.ordType = 'LIMIT';
params.side = 'SELL';
params.price = '1000';
params.qty = 1;
params.senderLocationId = 'IT';
params.account = 'BT';

import OrderMgmtSystem.*;
order(1) = OrderFuture(params);
order(1).createOrder();
order(1).sendOrder();
status(1) = order(1).checkOrderStatus()

%%
    import OrderMgmtSystem.*;


for k=1:7
    order(k) = OrderFuture(params);
    order(k).createOrder();
    order(k).sendOrder();
    status(k) = order(1).checkOrderStatus()
end
