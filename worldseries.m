function worldseries
%Giants 
GiantsLineup = ['Pagan' 'Theriot' 'Cabrera' 'Posey' 'Pence' 'Belt' 'Sandoval' 'Crawford' 'Cain']
Giants = 1
%Tigers
TigersLineup = ['Jackson' 'Infante' 'Cabrera' 'Fielder' 'Young' 'Boesch' 'Peralta' 'Berry' 'Avila'];
Tigers = 2


%Stats 
%These stats were obtained from www.baseball-reference.com for the 2012
%season averages of the Giants and Tigers. The simulations will utilize the
%individual batting stats of each player and will pull them from these two
%arrays. The order of the stats are given above in the lineups, and they
%are arranged in batting order.

                % 1.AB 2.PA 3.R 4.H	5.2B 6.3B 7.HR 8.RBI 9.SB 10.CS 11.BB 12.BA 13.HBP 14.SH 15.SF
GiantsStats = [605	659	95	174	38	15	8	56	29	7	48	0.288	0	2	4;
352	384	45	95	16	1	0	28	13	5	24	0.27	1	4	3;
459	501	84	159	25	10	11	60	13	5	36	0.346	0	1	5;
530	610	78	178	39	1	24	103	1	1	69	0.336	2	0	9;
219	248	28	48	11	2	7	45	1	0	19	0.219	4	1	5;
411	472	47	113	27	6	7	56	12	2	54	0.275	3	0	4;
396	442	59	112	25	2	12	63	1	1	38	0.283	1	0	7;
435	476	44	108	26	3	4	45	1	4	33	0.248	3	2	3;
74	84	6	13	2	0	1	6	0	0	2	0.176	0	8	0];


             % 1.AB 2.PA 3.R 4.H	5.2B 6.3B 7.HR 8.RBI 9.SB 10.CS 11.BB 12.BA 13.HBP 14.SH 15.SF
TigersStats = [543	617	103	163	29	10	16	66	12	9	67	0.3	2	2	3;
226	241	27	58	7	5	4	20	7	2	9	0.257	0	4	2;
622	697	109	205	40	0	44	139	4	1	66	0.33	3	0	6;
581	690	83	182	33	1	30	108	1	0	85	0.313	17	0	7;
574	608	54	153	27	1	18	74	0	2	20	0.267	7	0	7;
470	503	52	113	22	2	12	54	6	3	26	0.24	5	0	2;
531	585	58	127	32	3	13	63	1	2	49	0.239	2	1	2;
291	330	44	75	10	6	2	29	21	0	25	0.258	7	6	1;
367	434	42	89	21	2	9	48	2	0	61	0.243	2	2	2];

GiantsTotalSeriesWins = 0;
TigersTotalSeriesWins = 0;
GiantsActual = 0;


nthgame = 0;

for n = 1 : 1000         %Simulating seven game series 1000 times

    TigersWins = 0;
    GiantsWins = 0;
    
    game = 1;
    
    while game < 8         %Only a Maximum of 7 games 
        
        nthgame = nthgame + 1;
        
        for team = [1 2]            %Team 1 is Giants, Team 2 is Tigers
            if team == 1            %Switch stats between each team
                stats = GiantsStats;
            else
                stats = TigersStats;
            end
            
            totalouts = 0;
            score(team) = 0;
            
            while totalouts < 27    %Each team allowed 27 outs per game
                
                firstbase = 0;      
                secondbase = 0;
                thirdbase = 0;
                outs = 0;
                
                while outs < 3          %Inning
                    if totalouts == 0   %Game starts out with first pitcher in batting order
                        player = 1;
                    end
                    
                    if player == 10     %After player 9 bats, order re-sets to player 1
                        player = 1;
                    end
                    
                    %This function runs a quick simulation of the
                    %probability a stolen base will be attempted at the
                    %current at bat, based off baserunners 2012 totals for
                    %stealing bases
                    [base1Outcome, base2Outcome] = StealOrCaught(stats,firstbase,secondbase,thirdbase);
                    
                    if base2Outcome == 1
                        thirdbase = secondbase;
                        secondbase = 0;
                        
                    elseif base2Outcome == 2
                        secondbase = 0;
                        
                    end
                    
                    if base1Outcome == 1
                        secondbase = firstbase;
                        firstbase = 0;
                        
                    elseif base1Outcome == 2
                        firstbase = 0;
                        
                    end
                    
                   
                    Outcome = AtThePlate(stats(player,:),firstbase,secondbase,thirdbase);   %This function simulates an individual batting event, returns the outcome
                    
                    
                    %Resulting gameplay sequences.
                    %Outcome possibilities: 1. Single Base Hit 2. Double
                    %Base Hit 3.Triple Base Hit 4.Home Run 5. Strike Out
                    %6.Base on Balls 7.Hit By Pitch 8. Sacrifice Fly 9.
                    %Sacrifice Hit
                   
                    
                    if Outcome == 1
                        [secondbase,thirdbase,runs] = hit(Outcome,firstbase,secondbase,thirdbase);
                        firstbase = player;
                        score(team) = score(team) + runs;
                    elseif Outcome == 2
                        [~,thirdbase,runs] = hit(Outcome,firstbase,secondbase,thirdbase);
                        secondbase = player;
                        score(team) = score(team) + runs;
                    elseif Outcome == 3
                        [secondbase,~,runs] = hit(Outcome,firstbase,secondbase,thirdbase);
                        thirdbase = player;
                        score(team) = score(team) + runs;
                    elseif Outcome == 4
                        [secondbase,thirdbase,runs] = hit(Outcome,firstbase,secondbase,thirdbase);
                        score(team) = score(team) + runs;
                    elseif Outcome == 5
                        outs = outs + 1;
                        totalouts = totalouts + 1;
                    elseif Outcome == 6 || Outcome == 7
                        [secondbase,thirdbase,runs] = hit(1,firstbase,secondbase,thirdbase);
                        firstbase = player;
                        score(team) = score(team) + runs;
                    elseif Outcome == 8 || Outcome == 9
                        outs = outs + 1;
                        totalouts = totalouts + 1;
                        [secondbase,thirdbase,runs] = hit(1,firstbase,secondbase,thirdbase);
                        score(team) = score(team) + runs;
                        firstbase = 0;
                    end
                    
                    player = player + 1;        %Next player up to bat
                    
                    
                                      
                end
                
                
                
                
            end
            
            
        end
        
        
        %After Game, win is determined based off scores and allocated to
        %the respective winner. Game index is advanced
        
        if score(1) > score(2)
            GiantsWins = GiantsWins + 1;
            Final(:,game) = [score(1) ; score(2)];
            game = game + 1;
        elseif score(2) > score(1)
            TigersWins = TigersWins + 1;
            Final(:,game) = [score(1) ; score(2)];
            game = game + 1;
            
        end
        %Scores for the nth game are appended to a vector array which will
        %be used for statisfical analysis later
        GiantsScores(nthgame) = score(1);
        TigersScores(nthgame) = score(2);
        
        
        if TigersWins == 4 || GiantsWins == 4 %This condition will terminate the series if either team reaches four wins early.
            if TigersWins == 4
                if GiantsWins == 0
                    seriesbins(n) = 1; %Series outcome numbered in respective bin
                elseif GiantsWins == 1
                    seriesbins(n) = 2;
                elseif GiantsWins == 2
                    seriesbins(n) = 3;
                else
                    seriesbins(n) = 4;
                end
            else
                if TigersWins == 0
                    seriesbins(n) = 8;
                    GiantsActual = GiantsActual + 1;
                elseif TigersWins == 1
                    seriesbins(n) = 7;
                elseif TigersWins == 2
                    seriesbins(n) = 6;
                else
                    seriesbins(n) = 5;
                end
            end
            game = 8;
        end
        
        
        
        
    end
    
    %Results Table for a 7 game series
    disp(struct('GiantsScore', Final(1,:),'TigersScore', Final(2,:)));
    disp(struct('GiantsWins', GiantsWins, 'TigersWins', TigersWins));
    if GiantsWins > TigersWins
        disp('GIANTS WIN THE WORLD SERIES');
        GiantsTotalSeriesWins = GiantsTotalSeriesWins + 1;
    else
        disp('TIGERS WIN THE WORLD SERIES');
        TigersTotalSeriesWins = TigersTotalSeriesWins + 1;
    end
    clear Final





        
        
     
      
   
end
%Total Win Percentages displayed after 1000 simulations
%Plotting and Analysis, results discussed in attached document
disp(struct('GiantsWinPercentage',GiantsTotalSeriesWins/1000, 'TigersWinPercentage',TigersTotalSeriesWins/1000))

disp(struct('ProbabilityOfGiantsWinningSeries40', GiantsActual/1000))
disp(struct('GiantsMeanScore', mean(GiantsScores),'GiantsStdDev', std(GiantsScores))) 
disp(struct('TigersMeanScore', mean(TigersScores),'TigersStdDev', std(TigersScores))) 
muG = mean(GiantsScores);
muT =  mean(TigersScores);
sigG = std(GiantsScores);
sigT = std(TigersScores);
figure(1)
hist(seriesbins,8)
title('Histogram of 7 Game Series Win instances for each team per 1000 simulations')
xlabel('Series Outcomes')
ylabel('Occurances')
set(gca, 'xTick', 0:9)
set(gca,'xTickLabel',{'0'  'Tigers 4-0' 'Tigers 4-1' 'Tigers 4-2' 'Tigers 4-3' 'Giants 4-3' 'Giants 4-2' 'Giants 4-1' 'Giants 4-0'})

figure(2)
G = histc(GiantsScores,0:20);
T = histc(TigersScores,0:20);
bar([transpose(G) transpose(T)], 'grouped')
title('Score Distributions each game for each team with bin size = 1 point')
xlabel('Score')
ylabel('Occurances')
set(gca, 'xTick', 0:21)
A = num2cell([0     0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20]);
set(gca,'xTickLabel', A)

x = 0:0.01:20;
fG = exp(-(x-muG).^2./(2*sigG^2))/(sigG*sqrt(2*pi));
fT = exp(-(x-muT).^2./(2*sigT^2))/(sigT*sqrt(2*pi));
figure(3);
plot(x,fG,x,fT)
end


function [Outcome] = AtThePlate(stats,base1,base2,base3)
%This function uses individual batting statistics as probabilities to
%determine an outcome event for each player's plate appearance

    first = (stats(4)-stats(5)-stats(6)-stats(7))/stats(1);
    second = stats(5)/stats(1);
    third = stats(6)/stats(1);
    homer = stats(7)/stats(1);
    norun = 1 - (first+second+third+homer);
        %Outcome characterized by 1.go to first 2.second 3.third 4.homer
        %5. not a hit (may be BB, HBP, SF, SH, or SO)
        %x is a random number between 0 and 1 and each each probabiltiy
        %becomes a conditional value that x may or may not be less then.
    x = rand; 
    if x < norun
         Outcome = 5;
    elseif x < (norun+first)
         Outcome = 1;
    elseif x < (norun+first+second)
         Outcome = 2;
    elseif x < (norun+first+second+third)
         Outcome = 3;
    else
         Outcome = 4;
    end
    
    % For no hits, could be 5.SO 6.BB 7.HBP 8.SH 9.SF
    %This is for when there is no hit made, but 4 other options still must
    %be considered
    if Outcome == 5
        BB = stats(11)/(stats(1));
        HBP = stats(13)/(stats(1));
        SH =  stats(14)/(stats(1));
        SF =  stats(15)/(stats(1));
        SO = 1 -(BB+HBP+SH+SF);
        if base3 > 1        %This condition determines whether a sacrifice fly is a possibilty, as a player would only attempt one if there is someone on third base
            x2 = rand;
            if x2 < SO
                Outcome = 5;
            elseif x2 < (SO+BB)
                Outcome = 1;
            elseif x2 < (SO+BB+HBP)
                Outcome = 1;
            elseif x2 < (SO+BB+HBP+SH)
                Outcome = 8;
            else
                Outcome = 9;
            end
            
        elseif (base2+base1) > 1 %This determines if any bases are loaded, so that the possibility of a sacrifice hit is included.
            x2 = rand;
            if x2 < SO
                Outcome = 5;
            elseif x2 < (SO+BB)
                Outcome = 1;
            elseif x2 < (SO+BB+HBP)
                Outcome = 1;
            elseif x2 < (SO+BB+HBP+SH)
                Outcome = 8;
            end
    
        else
            x2 = rand;
            if x2 < SO
                Outcome = 5;
            elseif x2 < (SO+BB)
                Outcome = 1;
            elseif x2 < (SO+BB+HBP)
                Outcome = 1;
            else
                Outcome = 5;
            end
        end
     end         
    
end


function [secondbase,thirdbase,scoring] = hit(hit,base1,base2,base3)
%This function takes in the hit type and base situation and generates the
%gameplay sequence. The assumption here is that baserunners advance in a
%linear fashion, so a single will advance all baserunners one base, and a
%home run will score all baserunners. if a base is occupied by a player, it
%will have their batting order position as the base value.

    scoring = 0;
    if hit == 4
        scoring = 1;
        if base1 > 0
            scoring = scoring + 1;
        end
        if base2 > 0
            scoring = scoring + 1;
        end
        if base3 > 0
            scoring = scoring + 1;
        end
        secondbase = 0;
        thirdbase = 0;
    
    elseif hit == 1
       if base3 > 0
           scoring = 1;
       end
       thirdbase = base2;
       secondbase = base1;
       
    elseif hit == 2
        if base3 > 0
           scoring = 1;
        end
        if base2 > 0
           scoring = scoring + 1;
        end
        thirdbase = base1;
        secondbase = 0;
    elseif hit == 3
        if base3 > 0
           scoring = 1;
        end
        if base2 > 0
           scoring = scoring + 1;
        end
        if base1 > 0
            scoring = scoring + 1;
        end
        thirdbase = 0;
        secondbase = 0;
    end
     
        
        
       
        
       
       
       
        
   
            


end


function [base1Outcome, base2Outcome] = StealOrCaught(stats,base1,base2,base3)
    AvgPitchespergame2012 = 22 ;
    AvgPitchesperseason2012 = AvgPitchespergame2012*162;
    %0. No Attempt 1. Steals Base 2.Caught Stealing
    if base1 > 0 && base2 == 0
        %First Base
        stealsuccess = stats(base1,9)/AvgPitchesperseason2012;
        caughtstealing = stats(base1,10)/AvgPitchesperseason2012;
        noattempt = 1 - (stealsuccess + caughtstealing);
        x = rand;
        if x < noattempt
            base1Outcome = 0;
        elseif x < (noattempt + stealsuccess)
            base1Outcome = 1;
        else
            base1Outcome = 2;
        end
        
    else
        base1Outcome = 0;
    end
    
    if base2 > 0 && base3 == 0
        %Second Base
        stealsuccess = stats(base2,9)/AvgPitchesperseason2012;
        caughtstealing = stats(base2,10)/AvgPitchesperseason2012;
        noattempt = 1 - (stealsuccess + caughtstealing);
        x2 = rand;
        if x2 < noattempt
            base2Outcome = 0;
        elseif x2 < (noattempt + stealsuccess)
            base2Outcome = 1;
        else
            base2Outcome = 2;
        end
    
    else
        base2Outcome = 0;
    end
end


