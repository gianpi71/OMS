classdef OrderFuture < OrderMgmtSystem.OMS
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Order;
        orderId;
    end
    
    properties (Constant)
        securityType = 'FUT';
    end
    methods
       function OF = OrderFuture(params)
            OF = OF@OrderMgmtSystem.OMS(params);
        end % constructor
        
        function createOrder(OF)
            OF.orderId = num2str(now);
            
            OF.Order = struct( ...
                'secretKey', OF.secretKey, ...
                'orderId', OF.orderId, ...
                'qty', OF.qty, ...
                'ordType', OF.ordType, ...
                'side', OF.side, ...
                'price', OF.price, ...
                "senderLocationId", OF.senderLocationId, ...
                'instrument', OF.Instrument, ...
                'parties', OF.Parties);
        end
    end
end

