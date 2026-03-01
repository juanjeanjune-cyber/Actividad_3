clear all
close all
clc

% Parámetros
dt = 0.1;
Tf = 300;
t = 0;

grid_size = 50; %Cuadricula variable

x = 0;
y = 1.5; % 1.5 = 3x3 persona, 2.5 = 5x5 fuego
x_tray = [];
y_tray = [];

% Perturbación tipo viento
d_x = 0;
d_y = 0;

%Ubicacion de persona/fuego
x_persona = randi([0 grid_size])
y_persona = randi([0 grid_size])
% persona = [x_persona y_persona];

radio_deteccion = 1.6;   % 1.6 = 3x3 persona, 2.6 = 5x5 fuego

%Gps
c = 0;
Gx = [];
Gy = [];

%Interno
i = 0;
ix = [];
iy = [];

Vx = 10;  
Vy = 10;  

pasoY = 3; % 3 = 3x3 persona, 5 = 5x5 fuego
direccion = 1; 

figure(1)


while t < Tf

    c = c + 1;
    i = i + 1;
    
    x = x + direccion*Vx*dt;

    if x >= grid_size
        x = grid_size;
        direccion = -1;
        y = y + pasoY;
    end
    
    if x <= 0
        x = 0;
        direccion = 1;
        y = y + pasoY;
    end
    
  
    if y >= grid_size
        break
    end

    if abs(x - x_persona) <= radio_deteccion && ...
    abs(y - y_persona) <= radio_deteccion
        disp("Persona/fuego encontrada")
        break
    end

    
    % cada 15 segundos intentamos usar GPS
    if mod(c,15) == 0
            % GPS conectado → error mayor
            Gx(end+1) = x + (rand-0.5)*1;     % error ±0.5 km
            Gy(end+1) = y + (rand-0.5)*1;
    end

    if mod(i, 5) == 0
        ix(end+1) = x + (rand-0.5)*0.25; % Log the x-coordinate
        iy(end+1) = y + (rand-0.5)*0.25; % Log the y-coordinate
    end

    x_tray(end+1) = x;
    y_tray(end+1) = y;
    
    % Graficar
    clf
    plot(x_persona, y_persona, 'rp', 'MarkerSize',5, 'MarkerFaceColor','r')
    hold on
    plot(x,y,'bo','LineWidth',2)
    hold on
    axis([0 grid_size 0 grid_size])
    grid on
    plot(x_tray,y_tray,'Color','yellow','LineWidth',2)
    hold on
    plot(Gx,Gy,'Color','magenta','LineWidth',1)
    hold on
    plot(ix,iy,'Color','green','LineWidth',1)
    hold off
    title('Movimiento de drone')
    drawnow limitrate
    
    t = t + dt;
end