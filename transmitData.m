clc;
clear;
close all;
format long g   
numPackets = 10;
packetSize = 8000;
E_elec = 50e-9;             
E_fs   = 100e-12;           
initialEnergy = 1;     
senderPos   = [10 20];
receiverPos = [90 90];
distance = norm(senderPos - receiverPos);
senderEnergy   = initialEnergy;
receiverEnergy = initialEnergy;
remainingEnergySender   = zeros(1, numPackets);
remainingEnergyReceiver = zeros(1, numPackets);
for pkt = 1:numPackets
    E_tx = (E_elec * packetSize) + ...
           (E_fs * packetSize * distance^2);
    E_rx = E_elec * packetSize;
    senderEnergy   = senderEnergy - E_tx;
    receiverEnergy = receiverEnergy - E_rx;
    if senderEnergy < 0
        senderEnergy = 0;
    end
    if receiverEnergy < 0
        receiverEnergy = 0;
    end
    remainingEnergySender(pkt)   = senderEnergy;
    remainingEnergyReceiver(pkt) = receiverEnergy;
    fprintf('Packet %d | Sender Energy: %.8f J | Receiver Energy: %.8f J\n', ...
            pkt, senderEnergy, receiverEnergy);
    if senderEnergy == 0
        remainingEnergySender(pkt:end) = senderEnergy;
        remainingEnergyReceiver(pkt:end) = receiverEnergy;
        break;
    end
end
figure;
plot(1:numPackets, remainingEnergySender, '-o', 'LineWidth', 2);
hold on;
plot(1:numPackets, remainingEnergyReceiver, '-s', 'LineWidth', 2);
grid on;
xlabel('Number of Packets');
ylabel('Remaining Energy (Joules)');
title('Remaining Energy vs Number of Packets (Friis Model)');
legend('Sender', 'Receiver');
