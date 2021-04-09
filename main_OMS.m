clear all; close all; clc;

params.symbol = 'FESX';
params.securityExchange = 'EUREX';
params.maturityMonthYear = '202106';
params.executor = 'U370176';
params.investor = 'U370176';
params.secretKey = '93367bc1-8a0d-4f46-910f-48e2d06a9862';
params.ordType = 'LIMIT';
params.side = 'BUY';
params.price = '3831';
params.qty = 2;
params.senderLocationId = 'IT';
params.account = 'BT';
params.timeInForce = 'IC'; % 'CV'

import OrderMgmtSystem.*;
% order(1) = OrderFuture(params);
% order(1).createOrder();
% order(1).sendOrder();
% status(1) = order(1).checkOrderStatus()

%% example with 3 orders
clear order status;
import OrderMgmtSystem.*;


for k=1:3
    
    if k==1
        params.side = 'BUY';
        params.price = '3642';
        params.qty = 2;

    elseif k==2
        params.side = 'BUY';
        params.price = '3643';
        params.qty = 3;
    elseif k==3
        params.side = 'BUY';
        params.price = '3640.5';
        params.qty = 4;
    end
    
    order(k) = OrderFuture(params);
    order(k).createOrder();
    order(k).sendOrder();
end

pause(5);
for k=1:3
    status{k} = order(k).checkOrderStatus()
end

%% example to manage partially filles orders (this is the kind of algo to be included in out TS)
clear order status;
import OrderMgmtSystem.*;

params.ordType = 'LIMIT';
params.side = 'BUY';
params.price = 3644;
params.qty = 20;

order = OrderFuture(params);
order.createOrder();
order.sendOrder();
pause(2)
status = order.checkOrderStatus();

orderLoop = true;
filledQtyLoop = true;

while filledQtyLoop

while orderLoop
    S = numel(status);
    
    if isstruct(status)
        % when it is a struct it should be a cancelled order
        % however further check this below
        if strcmp(status(end).status,'4') | strcmp(status(end).status,'8') 
            % It's OK
            filledQty = 0;
            break;
        else
            error('Cell status response not CANCELLED or REJECTED as expected: check !!!!')
        end
        
    elseif iscell(status)
        for k=1:S
            
            % the only possible final states are '2' and '4' 
            % state '8' is final as well, bbut means that the order hasn't
            % been accepted by the market
            
            switch status{k}.status
                
                case '1' % partially filled
                    % insert here possible additional logic to manage partially
                    % filled orders
                    
                    % ==>> ASK GIULIO IF IT IS POSSIBLE TO CANCEL AN ORDER
                    
                    continue
                case '2' % filled
                    filledQty = status{k}.cumQty;
                case '4' % cancelled
                    filledQty = status{k}.cumQty;
                case '8' % rejected
                    filledQty = status{k}.cumQty;
            end
        end
        break
    end
    
end
disp(['Done: quantity filled = ',num2str(filledQty)]);

if filledQty==params.qty 
    filledQtyLoop = false; % exit the loop if params.qty has been filled 
else
    % can place here further logic to change the price if needed or to
    % limit the no of new orders to be generated for a complete fill
    % params.price =
end
end


%% GUI tests

% GUI
params.signalType = params.side;
params.signalPrice = params.price;
params.signalQty = params.qty;
% orderGUI(outfigure,signalType,signalPrice,signalQty)

orderPanel = orderGUI(params);
orderPanel.orderWindow()




