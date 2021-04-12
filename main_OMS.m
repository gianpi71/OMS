clear all; close all; clc;

params.symbol = 'FESX';
params.securityExchange = 'EUREX';
params.maturityMonthYear = '202106';
params.executor = 'U370176';
params.investor = 'U370176';
params.secretKey = '93367bc1-8a0d-4f46-910f-48e2d06a9862';
params.ordType = 'LIMIT';
params.side = 'SELL';
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

%% example to manage partially filled orders (this is the kind of algo to be included in our TS)
clear order status;
import OrderMgmtSystem.*;

params.ordType = 'LIMIT';
params.side = 'BUY';
params.price = 3643;
params.qty = 1;

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
        %  ** for k=1:S
            
            % the only possible final states are '2' and '4' 
            % state '8' is final as well, bbut means that the order hasn't
            % been accepted by the market
            STATUS = status{end}; % ** status{k}
            switch STATUS.status
                
                case '1' % partially filled
                    % insert here possible additional logic to manage partially
                    % filled orders
                    
                    % ==>> ASK GIULIO IF IT IS POSSIBLE TO CANCEL AN ORDER
                    
                    continue
                case '2' % filled
                    filledQty = STATUS.cumQty;
                    leavesQty = STATUS.leavesQty
                case '4' % cancelled
                    filledQty = STATUS.cumQty;
                    leavesQty = STATUS.leavesQty
                case '8' % rejected
                    filledQty = STATUS.cumQty;
                    leavesQty = STATUS.leavesQty
            end
        %  ** end
        break
    end
    
end
disp(['Done: quantity filled = ',num2str(filledQty)]);

if filledQty==params.qty 
    filledQtyLoop = false; % exit the loop if params.qty has been filled 
else
    % place here the logic to manage partially executed orders
    params.qty = leavesQty; % reset the qty to unexecuted qty
    % the price will be the original price or the latest price set in the
    % GUI by the user
end
end


%% GUI tests

% GUI
params.signalType = params.side;
params.signalPrice = params.price;
params.signalQty = params.qty;
params.tsName = 'Orange';
% orderGUI(outfigure,signalType,signalPrice,signalQty)

orderPanel = orderGUI(params);
orderPanel.orderWindow()


% AFTER GUI

% get feedback from GUI
sendFromGui = orderPanel.sendFromGui;
priceFromGui = orderPanel.priceFromGui;
delete(orderPanel);
clear orderPanel;

disp(['Send Signal = ',num2str(sendFromGui),' with Price = ',num2str(priceFromGui)]);


%% FULL TEST: random orders generation, GUI visualizaton, order routing

% outer loop to generate N orders
N = 10;

for n=1:N
    
clear order status;
import OrderMgmtSystem.*;

% % params.ordType = 'LIMIT';
% % params.side = 'BUY';
% % params.price = 3644;
% % params.qty = 20;
% % 
% % initialQty = params.qty; % <<<<=====
% % totQty = 0; % to keep track of executed quantities


if mod(n,2)==0
    params.side = 'BUY';
    if n==2
        params.ordType = 'LIMIT';
        params.price = 3643;
        params.qty = 10;
    elseif n==4
        params.ordType = 'MARKET';
        params.price = 3643;
        params.qty = 10;
    else
        params.ordType = 'LIMIT';
        params.price = 3645;
        params.qty = 10;
    end
else
    params.side = 'SELL';
    
    if n==1
        params.ordType = 'LIMIT';
        params.price = 3640.5;
        params.qty = 1000;
    elseif n==3
        params.ordType = 'MARKET';
        params.price = 3643;
        params.qty = 10;
    else
        params.ordType = 'LIMIT';
        params.price = 3640;
        params.qty = 10;
    end
end


initialQty = params.qty; % <<<<=====
totQty = 0; % to keep track of executed quantities

% order = OrderFuture(params);
% order.createOrder();
% order.sendOrder();
% pause(2)
% status = order.checkOrderStatus();

orderLoop = true;
filledQtyLoop = true;

while filledQtyLoop % until the whole 'initialQty' has been executed
    clear order status;

    % GUI to confirm the order
    % *********************************************************************
    guiParams.signalType = params.side;
    guiParams.signalPrice = params.price;
    guiParams.signalQty = params.qty;
    guiParams.tsName = 'Orange';
    
    orderPanel = orderGUI(guiParams);
    orderPanel.orderWindow()
    
    % AFTER GUI
    
    % get feedback from GUI
    sendFromGui = orderPanel.sendFromGui;
    priceFromGui = orderPanel.priceFromGui;
    delete(orderPanel);
    clear orderPanel;
    
    disp(['Send Signal = ',num2str(sendFromGui),' with Price = ',num2str(priceFromGui)]);
    % *********************************************************************
    
    if ~sendFromGui % the user will send the order manually
        break;
    end
    
    params.price = priceFromGui; % reset the price to the price set in the GUI
    order = OrderFuture(params);
    order.createOrder();
    order.sendOrder();
    pause(2)
    status = order.checkOrderStatus();
while orderLoop % until a 'final status' is reached
    S = numel(status);
    
    if isstruct(status)
        % when it is a struct it should be a cancelled order
        % however further check this below
        if strcmp(status(end).status,'4') | strcmp(status(end).status,'8') 
            % It's OK
            filledQty = 0;
            notFilledQty = params.qty - filledQty;
            break;
        else
            error('Cell status response not CANCELLED or REJECTED as expected: check !!!!')
        end
        
    elseif iscell(status)
        %  ** for k=1:S
            
            % the only possible final states are '2' and '4' 
            % state '8' is final as well, bbut means that the order hasn't
            % been accepted by the market
            STATUS = status{end}; % ** status{k}
            switch STATUS.status
                
                case '1' % partially filled
                    % insert here possible additional logic to manage partially
                    % filled orders
                    
                    % ==>> ASK GIULIO IF IT IS POSSIBLE TO CANCEL AN ORDER
                    
                    continue
                case '2' % filled
                    filledQty = STATUS.cumQty;
                    notFilledQty = params.qty - filledQty;
                case '4' % cancelled
                    filledQty = STATUS.cumQty;
                    notFilledQty = params.qty - filledQty;
                case '8' % rejected
                    filledQty = STATUS.cumQty;
                    notFilledQty = params.qty - filledQty;
            end
        %  ** end
        break
    end
    
end
disp(['Done: quantity filled = ',num2str(filledQty)]);

if filledQty==params.qty 
    filledQtyLoop = false; % exit the loop if params.qty has been filled 
    totQty = totQty + filledQty;
else
   % place here the logic to manage partially executed orders
    params.qty = notFilledQty; % reset the qty to unexecuted qty
    % the price will be the original price or the latest price set in the
    % GUI by the user
end
end

totQty == initialQty;


pause(5);
end % n-loop