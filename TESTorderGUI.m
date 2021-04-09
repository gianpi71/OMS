function orderGUI(outfigure,signalType,signalPrice,signalQty)

signalType = 'BUY';
signalQty = 10;
signalPrice = 3740;

f = figure ('Visible','off','Tag','OrderWindow','CloseRequestFcn',@figureClose);
f.Position = [10 320 650 350];
f.Name = strcat("  ASW MONITOR  ", 'cc');
% axes('Units','Pixels','Position',[600,50,620,260]);
movegui(f,'north')
f.Visible = 'on';

% Text
% display signal type (BUY or SELL)
LeftDisplacement = 70;
BottomDisplacement = 310;
Width = 200;
Height = 30;
uicontrol(f, ...
    'Style', 'edit', 'enable', 'inactive', 'HorizontalAlignment', 'center', ...
    'String', signalType,...
    'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 20, 'BackgroundColor', [.8, .8, .8])

% display signal quantity
LeftDisplacement = 70;
BottomDisplacement = 270;
Width = 200;
Height = 30;
uicontrol(f, ...
    'Style', 'edit', 'enable', 'inactive', 'HorizontalAlignment', 'center', ...
    'String', num2str(signalQty),...
    'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 20, 'BackgroundColor', [.8, .8, .8])

% Editable Text
% displat editable price
LeftDisplacement = 70;
BottomDisplacement = 150;
Width = 200;
Height = 30;
uicontrol(f, ...
    'Style', 'edit', 'enable', 'on', 'HorizontalAlignment', 'left', ...
    'String', num2str(signalPrice),...
    'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], 'FontSize', 12, 'BackgroundColor', [.8, .8, .8], ...
    'Tag','priceBox');

% Popupmenu
% c = uicontrol(f, ...
%     'Style', 'popupmenu', 'HorizontalAlignment', 'left', ...
%     'String', monitorType,...
%     'Position' , [20, 240, 500, 60], 'FontSize', 14, ...
%     'Callback' , @countrySelection);

% Pushbuttons

% Button to confirm
LeftDisplacement = 70;
BottomDisplacement = 50;
Width = 200;
Height = 30;
uicontrol(f, ...
          'Style', 'pushbutton', ...
          'String', 'Send Order to Market', ...
          'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], ...
          'FontSize', 14, ...
          'FontWeight', 'bold', ...
          'Callback', @sendOrder);

% Button to cancel
LeftDisplacement = 380;
BottomDisplacement = 50;
Width = 200;
Height = 30;
uicontrol(f, ...
          'Style', 'pushbutton', ...
          'String', 'Do not Send (execute manually)', ...
          'Position' , [LeftDisplacement, BottomDisplacement, Width, Height], ...
          'FontSize', 12, ...
          'Callback', @doNotSendOrder);
      
end

function sendOrder(source,callbackdata,outfigure)
% send order and close all figures

        % Close all figure with empty Tag property
%         allFigures = findobj('Type','Figure','Tag','priceBox','-or','Tag','AllBonds');
        priceBoxUI = findobj(f,'Tag','priceBox','-or','Tag','AllBonds');
        priceString = priceBoxUI.String;
        orderWindow_h = findobj('Type','Figure','Tag','OrderWindow')
        delete(orderWindow_h)
end

function doNotSendOrder(source,callbackdata,outfigure)

        orderWindow_h = findobj('Type','Figure','Tag','OrderWindow')
        delete(orderWindow_h);
        
        % TODO: can place a warning here
end

function figureClose(source,callbackdata,outfigure)
    h=msgbox('This panel cannot be closed: use one of the buttons provided in the window','Error');
    uiwait(h); 
end