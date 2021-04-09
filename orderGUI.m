classdef orderGUI < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        signalType;
        signalQty;
        signalPrice;
        priceFromGui;
        sendFromGui;
    end
    
    properties (SetAccess = protected)
        f; % main figure handle
    end
    
    methods
        function G = orderGUI(params)
            G.signalType = params.signalType;
            G.signalQty = params.signalQty;
            G.signalPrice = params.signalPrice;
            G.sendFromGui = false;
        end % constructor
        
        function orderWindow(G)
            
            G.f = figure ('Visible','off','Tag','OrderWindow','CloseRequestFcn',@(h,e)G.figureClose);
            G.f.Position = [10 320 650 350];
            G.f.Name = strcat("  ASW MONITOR  ", 'cc');
            movegui(G.f,'north')
            G.f.Visible = 'on';
            
            % Text
            % display signal type (BUY or SELL)
            LeftDisplacement = 210;
            BottomDisplacement = 310;
            Width = 200;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'text', 'enable', 'inactive', 'HorizontalAlignment', 'center', ...
                'String', G.signalType,...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 20, 'BackgroundColor', [.8, .8, .8])
            
            % display signal quantity
            LeftDisplacement = 70;
            BottomDisplacement = 200;
            Width = 150;
            Height = 30;
            uicontrol(G.f, ...
                'Style', 'text', 'enable', 'inactive', 'HorizontalAlignment', 'left', ...
                'String', ['Quantity: ',num2str(G.signalQty)],...
                'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 18, 'BackgroundColor', [.8, .8, .8])
            
                     
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
            orderWindow_h = findobj('Type','Figure','Tag','OrderWindow')
            delete(orderWindow_h)
        end
        
        function doNotSendOrder(G)
            % simply delete the figure and get back to the caller
            G.sendFromGui = false;
            orderWindow_h = findobj('Type','Figure','Tag','OrderWindow')
            delete(orderWindow_h);
            
            % TODO: can place a warning here
        end
        
        function figureClose(G)
            h=msgbox('This panel cannot be closed: use one of the buttons provided in the window','Error');
            uiwait(h);
        end
        
    end %public methods
end %classdef

