classdef orderGUI < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        signalType;
        signalQty;
        signalPrice;
        priceFromGui;
        sendFromGui;
        tsName;
    end
    
    properties (SetAccess = protected)
        f; % main figure handle
    end
    
    methods
        function G = orderGUI(params)
            G.signalType = params.signalType;
            G.signalQty = params.signalQty;
            G.signalPrice = params.signalPrice;
            G.tsName = params.tsName;
            G.sendFromGui = false;
            
        end % constructor
        
        function orderWindow(G)
            
            G.f = figure ('Visible','off','Tag','OrderWindow','CloseRequestFcn',@(h,e)G.figureClose);
            G.f.Position = [10 320 650 350];
            G.f.Name = G.tsName;
            movegui(G.f,'north')
            G.f.Visible = 'on';
            
            set(G.f,'UserData','stay'); % the GUI will wait the this proèperty is set to goAhead before closing and allow the caller to resume execution
            
            % Text
            % display signal type (BUY or SELL)
            LeftDisplacement = 210;
            BottomDisplacement = 310;
            Width = 200;
            Height = 30;
            
            if strcmp(G.signalType,'BUY')
                backGroundColor = [1 1 0];
                foregroundColor  = [0 1 0];
            elseif strcmp(G.signalType,'SELL')
                backGroundColor = [1 1 0];
                foregroundColor = [1 0 0];
            end
            
            
            uicontrol(G.f, ...
                'Style', 'text', 'enable', 'inactive', 'HorizontalAlignment', 'center', ...
                'String', G.signalType,...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 20, 'BackgroundColor', backGroundColor, ...
                'ForegroundColor', foregroundColor, 'FontWeight', 'bold');
            
            % display signal quantity
            LeftDisplacement = 70;
            BottomDisplacement = 200;
            Width = 200;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'text', 'enable', 'inactive', 'HorizontalAlignment', 'left', ...
                'String', ['Quantity: ',num2str(G.signalQty)],...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 18, 'BackgroundColor', [.8, .8, .8]);
            
                     
            % Test: 'Price'
            LeftDisplacement = 70;
            BottomDisplacement = 150;
            Width = 140;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'text', 'enable', 'on', 'HorizontalAlignment', 'left', ...
                'String', 'Price: ',...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 18, 'BackgroundColor', [.8, .8, .8]);
            
            LeftDisplacement = 140;
            BottomDisplacement = 150;
            Width = 150;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'edit', 'enable', 'on', 'HorizontalAlignment', 'center', ...
                'String', num2str(G.signalPrice),...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 18, 'BackgroundColor', [1, 1, 1], ...
                'Tag','priceBox');
            
            % Popupmenu
            % c = uicontrol(f, ...
            %     'Style', 'popupmenu', 'HorizontalAlignment', 'left', ...
            %     'String', monitorType,...
            %     'Position' , [20, 240, 500, 60], 'FontSize', 14, ...
            %     'Callback' , @countrySelection);
            
            % Pushbuttons
            
            % Button to confirm
            LeftDisplacement = 30;
            BottomDisplacement = 50;
            Width = 250;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'pushbutton', ...
                'String', 'Send Order to Market', ...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'Callback', @(h,e)G.sendOrder);
            
            % Button to cancel
            LeftDisplacement = 360;
            BottomDisplacement = 50;
            Width = 250;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'pushbutton', ...
                'String', 'Do not Send (execute manually)', ...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], ...
                'FontSize', 12, ...
                'Callback', @(h,e)G.doNotSendOrder);
            
            waitfor(G.f,'UserData','goAhead');
            orderWindow_h = findobj('Type','Figure','Tag','OrderWindow')
            delete(orderWindow_h);
        end % orderWindow
        
        function sendOrder(G)
            % send order and close all figures
            
            % Close all figure with empty Tag property
            %         allFigures = findobj('Type','Figure','Tag','priceBox','-or','Tag','AllBonds');
            priceBoxUI = findobj(G.f,'Tag','priceBox','-or','Tag','AllBonds');
            priceString = priceBoxUI.String;
            p = str2num(priceString);;
            if isempty(p) % empty or not a number
               priceBoxUI.String = '';
               return; 
            end
            G.priceFromGui = p; 
            G.sendFromGui = true;
            set(G.f,'UserData','goAhead'); % signal that the GUI can be closed and the caller code execution resume

        end % sendOrder
        
        function doNotSendOrder(G)
            % make  second check
            selection = questdlg('The order wont be sent to the market. Are you sure ?',...
                'Cancel Confirmation',...
                'Yes','No','Yes');
            
            switch selection
                case 'Yes'
                    % simply delete the figure and get back to the caller
                    G.sendFromGui = false;
                    G.priceFromGui = [];
                    set(G.f,'UserData','goAhead'); % signal that the GUI can be closed and the caller code execution resume

                case 'No'
                    return
            end
            
        end % doNotSendOrder
        
        function figureClose(G)
            h=msgbox('This panel cannot be closed: use one of the buttons provided in the window','Error');
            uiwait(h);
        end % figureClose
        
    end %public methods
end %classdef

