function EEG=PurgeNonLockEvent(EEG)

j=0;

if isfield(EEG, 'epoch');
    for i=1:length(EEG.epoch(1).event);
        for ii=1:length(EEG.epoch);
            for iii=1:length(EEG.epoch(ii).event);
                if iscell(EEG.epoch(1).eventlatency);
                    if strcmp(EEG.epoch(ii).eventtype(iii),EEG.epoch(1).eventtype(i))&cell2mat(EEG.epoch(ii).eventlatency(iii))==cell2mat(EEG.epoch(1).eventlatency(i));
                        j=j+1;
                        MatchVector(j,:)=[i,ii,iii];
                    end
                else
                    if strcmp(EEG.epoch(ii).eventtype(iii),EEG.epoch(1).eventtype(i))&EEG.epoch(ii).eventlatency(iii)==EEG.epoch(1).eventlatency(i);
                        j=j+1;
                        MatchVector(j,:)=[i,ii,iii];
                    end                    
                end
            end
        end
    end
end

%disp(MatchVector);

j=0;

UniqueMatchEventIndexes=unique(MatchVector(:,1));
for i=1:length(UniqueMatchEventIndexes);
    if length(find(MatchVector(:,1)==UniqueMatchEventIndexes(i)))==EEG.trials;
        
        x=MatchVector(find(MatchVector(:,1)==UniqueMatchEventIndexes(i)),2:3);
        for ii=1:length(x(:,1));
            j=j+1;
            TempIndex(j)=EEG.epoch(x(ii,1)).event(x(ii,2));
        end
        
        
    end
end

if exist('TempIndex');
    for i=1:length(TempIndex);
        Temp.event(i)=EEG.event(TempIndex(i));
    end
    rmfield(EEG,'event');
    EEG.event=Temp.event;
else
    EEG.event=[];
end

EEG=eeg_checkset(EEG,'eventconsistency');
eeglab redraw