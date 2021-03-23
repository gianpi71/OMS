classdef (Abstract) OMS < handle

    properties
        thisOrder;
    end
    
    properties (Constant)
        % TODO: set the user ID automatically in the url (get it from env
        % variable)
        send_order_url = 'http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/U370176/fastfill/orders/createSimple';
        send_options = weboptions('RequestMethod','post', 'MediaType','application/json','Timeout',60);
    end
    
    properties (Abstract)
        Order;
    end
    
    properties (SetAccess = immutable) 
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
    end
    
    methods
        function O = OMS(params)
            O.secretKey = params.secretKey;
            O.qty = params.qty;
            O.ordType = params.ordType;
            
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
            O.thisOrder = webwrite(O.send_order_url, O.Order, O.send_options);

        end
        
        function status = checkOrderStatus(O)
            status_request_url = ['http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/U370176/fastfill/history/',O.orderId]';
            status_options = weboptions('RequestMethod','get', 'MediaType','application/json','Timeout',60);
            status = webread(status_request_url,status_options);
        end
    end
    
    methods (Abstract)
        createOrder;
    end % abstract methods
    
    methods (Static)
        
    end % static methods
end

