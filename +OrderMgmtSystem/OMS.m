classdef (Abstract) OMS < handle

    properties
        thisOrder;
    end
    
    properties (Constant)
        send_options = weboptions('RequestMethod','post', 'MediaType','application/json','Timeout',60);
    end
    
    properties (Abstract)
        Order;
    end
    
    properties (SetAccess = immutable) 
        send_order_url;
        status_request_url;
        params;
    end
    
    properties (SetAccess = protected)
        secretKey;
        qty;
        ordType;
        side;
        price;
        senderLocationId;
        Instrument;
        Parties;
        timeInForce;
    end
    
    methods
        function O = OMS(params)
            O.secretKey = params.secretKey;
            O.qty = params.qty;
            O.ordType = params.ordType;
            O.timeInForce = params.timeInForce;
            
            O.send_order_url = ['http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/',params.executor,'/fastfill/orders/createSimple'];
            O.status_request_url = ['http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/',params.executor,'/fastfill/history/'];
            
            O.side = params.side;
            O.price = params.price;
            O.senderLocationId = params.senderLocationId;
            
            O.Instrument = struct('symbol',params.symbol, ...
                'securityExchange', params.securityExchange, ...
                'securityType', O.securityType, ...
                'maturityMonthYear', params.maturityMonthYear);
            
            O.Parties = struct( ...
                'account',params.account, ...
                'executor',params.executor, ...
                'investor',params.investor);
            
            
        end % constructor
        
        
        
        function sendOrder(O)
            O.thisOrder = webwrite(O.send_order_url, O.Order); %,O.send_options

        end
        
        function status = checkOrderStatus(O)
            status_options = weboptions('RequestMethod','get', 'MediaType','application/json','Timeout',60);
            status = webread([O.status_request_url,O.orderId],status_options);
        end
    end
    
    methods (Abstract)
        createOrder;
    end % abstract methods
    
    methods (Static)
        
    end % static methods
end

