function LSEx_gen

% By using the Lindenmayer Sytem Generator you can generate predefined
% Lindenmayer systems (e.g. Fibonacci) or you can define your own 
% rules to create grammars. 
% 
% See detailed description about the usage and the parameters in the 
% User Manual or by pressing the help button.
% 
% For help and support feel free to contact: l-s-ex@gmx.co.uk
% 
% LSEx.m by Michael Lindner and Jamesd Douglas Saddy is licensed
% under CC BY 4.0
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY;
%
% Version 1.0 by Michael Lindner 
% University of Reading, 2017
% Center for Integrative Neuroscience and Neurodynamics
%
% 

clear

global rule grammars rule_edit hmenu rule_arrow voc_length hfig huser rule_edit_user ruletype repgui actpath rule_def gra_name

BackgroundColor=[.7 .7 .7];
BackgroundColor2=[1 1 1];
startvalue='';

grammars=get_default_rules;
cfg.figure_pos=calculate_figure_pos;

actpath=pwd;

if exist('generator_user_rules.mat', 'file') == 2
            load('generator_user_rules.mat')
            
end

ver='0.92beta';


hfig=figure('Name', 'Lindenmayer Systems Generator', ...
    'Visible', 'on', 'Units', 'pixels', ...
    'MenuBar', 'none', 'ToolBar', 'none', ...
    'Resize', 'off', 'NumberTitle', 'off',...
    'Position', cfg.figure_pos,...
    'Color',BackgroundColor);


uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,430,200,20], ...
    'String','Select L-system:',...
    'BackgroundColor',BackgroundColor);
GUI.grammar_type=uicontrol('Style', 'popupmenu',...
    'String', grammars.name,...
    'Value', 1,...
    'Units', 'pixels', ...
    'Position', [10,395,380,30],...
    'Callback',@grammar_function,...
    'BackgroundColor',BackgroundColor2);



%start value
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[50,288,200,20], ...
    'String','Start value:',...
    'BackgroundColor',BackgroundColor);
GUI.start_value=uicontrol('Style', 'edit',...
    'String', startvalue,...
    'BackgroundColor',BackgroundColor2,...
    'Position', [250,290,100,20]);

% number of recursions
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[50,258,200,20], ...
    'String','Number of recursions:',...
    'BackgroundColor',BackgroundColor);
GUI.rec_value=uicontrol('Style', 'edit',...
    'String', '',...
    'BackgroundColor',BackgroundColor2,...
    'Position', [250,260,100,20]);


% output folder
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,210,200,20], ...
    'String','Specify output folder:',...
    'BackgroundColor',BackgroundColor);
GUI.output_folder=uicontrol('Style', 'edit',...
    'String', actpath,...
    'BackgroundColor',BackgroundColor2,...
    'Position', [20,190,280,20]);
GUI.button_browse=uicontrol('Style', 'pushbutton', ...
    'Tag', 'Browse',...
    'String', 'Browse', ...
    'Units', 'pixels',...
    'Position', [310,190,70,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@browse_button);


% output file name
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,158,150,20], ...
    'String','Output file prefix:',...
    'BackgroundColor',BackgroundColor);
GUI.output_filename=uicontrol('Style', 'edit',...
    'String', 'output',...
    'BackgroundColor',BackgroundColor2,...
    'Position', [160,160,200,20]);


% output file type
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,130,150,20], ...
    'String','Select output type:',...
    'BackgroundColor',BackgroundColor);

GUI.checkbox_mat=uicontrol('Style','checkbox', ...
    'HorizontalAlignment','left', ...
    'Position',[200,130,20,20], ...
    'BackgroundColor',BackgroundColor,...
    'value',1);

uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[230,127,150,20], ...
    'String','MATLAB (.mat)',...
    'BackgroundColor',BackgroundColor);

GUI.checkbox_txt=uicontrol('Style','checkbox', ...
    'HorizontalAlignment','left', ...
    'Position',[200,110,20,20], ...
    'BackgroundColor',BackgroundColor,...
    'value',0);

uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[230,107,150,20], ...
    'String','Text (.txt)',...
    'BackgroundColor',BackgroundColor);


% generate button
GUI.button_start=uicontrol('Style', 'pushbutton', ...
    'Tag', 'button_quit',...
    'String', 'Generate L-system', ...
    'Units', 'pixels',...
    'Position', [10,50,380,40],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@generate_function);

% about button - as pushbutton - bottom right
GUI.button_back=uicontrol('Style', 'pushbutton', ...
    'String', 'Back', ...
    'Units', 'pixels',...
    'Position', [10,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@back_function);


% about button - as pushbutton - bottom right
GUI.button_about=uicontrol('Style', 'pushbutton', ...
    'String', 'Help', ...
    'Units', 'pixels',...
    'Position', [150,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@about_function);


% quit button - as pushbutton - bottom right
GUI.button_quit=uicontrol('Style', 'pushbutton', ...
    'String', 'Quit', ...
    'Units', 'pixels',...
    'Position', [290,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@quit_function);


uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[10,3,390,10], ...
    'FontSize',6,...
    'ForegroundColor',[.55 .55 .55],...
    'String',['Lindenmayer generator v',ver,' by Michael Lindner and Doug Saddy, University of Reading'],...
    'BackgroundColor',BackgroundColor);



grammar_function

a = axes;
set(a, 'Visible', 'off');
%# Stretch the axes over the whole figure.
set(a, 'Position', [0, 0, 1, 1]);
%# Switch off autoscaling.
set(a, 'Xlim', [0, 1], 'YLim', [0, 1]);
line([0.05,.95], [0.71, 0.71], 'Parent', a, 'Color',[.6 .6 .6])
line([0.05,.95], [0.53, 0.53], 'Parent', a, 'Color',[.6 .6 .6])
line([0.05,.95], [0.215, 0.215], 'Parent', a, 'Color',[.6 .6 .6])

  
    function generate_function(~,~)
        
        % generate grammar
        start=get(GUI.start_value,'String');
        recursions=uint8(str2double(get(GUI.rec_value,'String')));
        if recursions<1
            errordlg('Number of recursion must be a positive intager value!','Input error')
            error('Number of recursion must be a positive intager value!')
        end
        
        
        folder=get(GUI.output_folder,'String');
        if isempty(folder)
            errordlg('You need to select an output folder!','Input error')
            error('You need to select an output folder!')
        end
        
        if ruletype==1
            [grammar,grammar_length]=generator_classic(start,rule,recursions);
            filesuffix = '_clas_';
        elseif ruletype==2
            [grammar,grammar_length]=generator_extended(start,rule,recursions);
            fn_rep={'step','cont', 'contskip'};
            filesuffix = ['_ext_' fn_rep{cfg.reptype},'_'];
        end
        % save grammar
        folder=get(GUI.output_folder,'String');
        if isempty(folder)
            warndlg('You need to select an output folder!')
        end
        
        gra_name_cor=strrep(gra_name,' ','_');
        filename=[get(GUI.output_filename,'String'),'_',gra_name_cor];
        
       
        xxx=rand();
        if get(GUI.checkbox_mat,'Value')
            %             filename1=[filename,'.mat'];
            savename=fullfile(folder,[filename,filesuffix,datestr(now, 'dd-mmm-yyyy'),'.mat']);
            if exist(savename, 'file') == 2
                savename=fullfile(folder,[filename,filesuffix,datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'.mat']);
            end
            save(savename,'grammar','grammar_length','rule')
        end
        if get(GUI.checkbox_txt,'Value')
            savename1=fullfile(folder,[filename,filesuffix,'grammar_',datestr(now, 'dd-mmm-yyyy'),'.txt']);
            if exist(savename1, 'file') == 2
                savename1=fullfile(folder,[filename,filesuffix,'grammar_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'.txt']);
            end
            fid=fopen(savename1,'w');
            for ii=1:size(grammar,1)
                fprintf(fid,grammar{ii});
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            savename2=fullfile(folder,[filename,filesuffix,'grammar_length_',datestr(now, 'dd-mmm-yyyy'),'.txt']);
            if exist(savename2, 'file') == 2
                savename2=fullfile(folder,[filename,filesuffix,'grammar_length_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'.txt']);
            end
            
            fid=fopen(savename2,'w');
            for ii=1:size(grammar,1)
                fprintf(fid,num2str(grammar_length(ii)));
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            
            savename3=fullfile(folder,[filename,filesuffix,'rule_',datestr(now, 'dd-mmm-yyyy'),'.txt']);
            if exist(savename3, 'file') == 2
                savename3=fullfile(folder,[filename,filesuffix,'rule_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'.txt']);
            end
            
            fid=fopen(savename3,'w');
            for ii=1:size(rule,1)
                fprintf(fid,[rule{ii,1},' ---> ',rule{ii,2}]);
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            
        end
    end


    function [gram,gram_length]=generator_classic(start,rule,recursions)
        
        %create empty cells and matrices
        gram=cell(recursions,1);
        gram_length=zeros(recursions,1);
        
        % check start value for values which are not in the rule
        cc=0;
        for rr=1:size(rule,2)
            cc=cc+length(strfind(start,rule{1,rr}));
        end
        if cc~=length(start)
            errordlg('Start value contains more values than the rules!')
        end
        
        % get and store start value
        x=start;
        gram{1}=x;
        gram_length(1)=length(x);
        disp(x)
        
        % start generating the recursions
        count=1;
        for rr=1:recursions
            count=count+1;
            %create empty cell
            c=cell(1,length(x));
            
            for ii=1:size(rule,1)
                % find posiiton to replace
                pos=strfind(x,rule{ii,1});
                % replace concerning the rule
                % by putting the new string into the cell
                
                c(pos)={rule{ii,2}}; %#ok<CCAT1>
                
                d=find(cellfun(@isempty,c));
                for dd=d
                    c{dd}=x(dd);
                end
            end
            % join strings in cell array into single string
            x=cell2str(c);
            
            % store recursions
            gram{count}=x;
            gram_length(count)=length(x);
            disp(x)
        end
        
    end



    function [gram,gram_length]=generator_extended(start,rule,recursions)
        
        %create empty cells and matrices
        gram=cell(recursions,1);
        gram_length=zeros(recursions,1);
        
        % check start value for values which are not in the rule
        %         cc=0;
        %         for rr=1:size(rule,2)
        %             cc=cc+length(strfind(start,rule{1,rr}));
        %         end
        %         if cc~=length(start)
        %             errordlg('Start value contains more values than the rules!')
        %         end
        
        % get nr replace values from rule
        if cfg.reptype==1
            l=nan(size(rule,1),1);
            for ii=1:size(rule,1)
                l(ii)=length(rule{ii,1});
            end
            if cfg.reptype==1
                if min(l)~=max(l)
                    error('For segmentwise replacement all rules need to have the same source length!')
                end
            end
            maxl=max(l);
        end
        
        % get and store start value
        x=start;
        gram{1}=x;
        gram_length(1)=length(x);
        disp(x)
        
        % start generating the recursions
        count=1;
        for rr=1:recursions
            count=count+1;
            if cfg.reptype==1
                
                % calculate steps
                s2s=1:max(l):floor(length(x)/max(l))*max(l);
                
                c=cell(1,length(s2s));
                
                ccount=0;
                for ii=s2s
                    ccount=ccount+1;
                    ruledetect=0;
                    for rul=1:size(rule,1)
                        if strcmp(x(ii:ii+maxl-1),rule{rul,1})
                            c{ccount}=rule{rul,2};
                            ruledetect=1;
                        end
                    end
                    if ruledetect==0
                        c{ccount}=x(ii:ii+maxl-1);
                    end
                    
                end
                
                x=cell2str(c);
                
                % store recursions
                gram{count}=x;
                gram_length(count)=length(x);
                disp(x)
                
            else
                
                c=cell(1,length(x));
                
                ii=0;
                while ii<length(x)
                    ii=ii+1;
                    % fprintf(['\n',num2str(ii)])
                    
                    r=0;
                    for rul=1:size(rule,1)
                        try %#ok<TRYNC>
                            % fprintf([' - ',num2str(rul),':',num2str(strcmp(x(ii:ii+length(rule{rul,1})-1),rule{rul,1}))])
                            if strcmp(x(ii:ii+length(rule{rul,1})-1),rule{rul,1})
                                c{ii}=rule{rul,2};
                                if cfg.reptype==3
                                    ii=ii+length(rule{rul,1})-1;
                                end
                                r=r+1;
                            end
                        catch 
                            r=1;
                        end
                    end
                    % fprintf([' - ',num2str(r)])
                    if r==0
                        c{ii}=x(ii);
                    end
                    
                end
                
                if cfg.reptype==3
                    c2cut=find(cellfun(@isempty,c));
                    c(c2cut)=[];
                end
                
                x=cell2str(c);
                
                % store recursions
                gram{count}=x;
                gram_length(count)=length(x);
                disp(x)
            end
        end
    end



    function grammar_function(~,~)
        
        try %#ok<TRYNC>
            delete( rule_edit );
            delete( rule_arrow);
        end
        
        rpos=[375,345];
        
        gra=get(GUI.grammar_type,'Value');
        if gra<9
            
            % predefined grammars
            for voc=1:grammars.values{gra}
                rule_edit(voc,1)=uicontrol('Style', 'edit',...
                    'String', grammars.rules{gra}{voc,1},...
                    'Position', [50,rpos(voc),100,20],...
                    'Enable','off',...
                    'BackgroundColor',BackgroundColor);
                rule_arrow(voc)=uicontrol('Style','text', ...
                    'HorizontalAlignment','left', ...
                    'Position',[200,rpos(voc),40,20], ...
                    'String','-->',...
                    'BackgroundColor',BackgroundColor);
                rule_edit(voc,2)=uicontrol('Style', 'edit',...
                    'String', grammars.rules{gra}{voc,2},...
                    'Position', [250,rpos(voc),100,20],...
                    'Enable','off',...
                    'BackgroundColor',BackgroundColor);
            end
            rule=grammars.rules{gra};
            startvalue=grammars.start{gra};
            set(GUI.start_value,'String',grammars.start{gra});
            ruletype=1;
        elseif gra==9
            %create user defined grammar
            user_defined_select
        elseif gra>9
            rule=grammars.rules{gra};
            startvalue=grammars.start{gra};
            set(GUI.start_value,'String',grammars.start{gra});
            ruletype=grammars.ruletype{gra}; 
            
            vis{1}=['Rule: ',grammars.name{gra}];
            for nn=1:size(grammars.rules{gra},1)
                vis{nn+1}=[grammars.rules{gra}{nn,1},' ---> ',grammars.rules{gra}{nn,2}];
            end
            msgbox(vis,'Rules:')
        
            if ruletype==2
                select_replacetype
            end
            
        end
        
        gra_name=grammars.name{gra};      
        
    end


    function user_defined_select
        
        cfg.figure_pos_user=cfg.figure_pos;
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2;
        cfg.figure_pos_user(3)= 275;
        cfg.figure_pos_user(4)= 150;
        
        huser=figure('Tag', 'Define rules', 'Name', 'Rule types', ...
            'Visible', 'on', 'Units', 'pixels', ...
            'MenuBar', 'none', 'ToolBar', 'none', ...
            'Resize', 'off', 'NumberTitle', 'off',...
            'Position', cfg.figure_pos_user,...
            'Color',BackgroundColor);
        
        % quit button - as pushbutton - bottom right
        button_classic=uicontrol('Style', 'pushbutton', ...
            'String', '<html><center><b>Classic</b><br><br>replace one with n characters</center>', ...
            'Units', 'pixels',...
            'Position', [25,10,100,120],...
            'Callback',@classic);
        button_extended=uicontrol('Style', 'pushbutton', ...
            'String', '<html><center><b>Extended</b><br><br>replace m with n characters</center>', ...
            'Units', 'pixels',...
            'Position', [150,10,100,120],...
            'Callback',@extended);
        
    end


    function classic(~,~)
        ruletype=1;
        close(huser)
        user_defined
    end
    function extended(~,~)
        ruletype=2;
        close(huser)
        user_defined
    end

    function user_defined
        
        rule=cell(1,1);
        
        voc_length_str = inputdlg('How many rules (different replacements) do you want to define?',...
            'Variables', [1 50]);
        voc_length = str2double(voc_length_str{:});
        
        cfg.figure_pos_user=cfg.figure_pos;
        
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        cfg.figure_pos_user(4)= voc_length*40+80;
        upos=80:40:voc_length*40+80;
        
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2-cfg.figure_pos_user(4)/2;
        
        
        huser=figure('Tag', 'Define rules', 'Name', 'Define rules', ...
            'Visible', 'on', 'Units', 'pixels', ...
            'MenuBar', 'none', 'ToolBar', 'none', ...
            'Resize', 'off', 'NumberTitle', 'off',...
            'Position', cfg.figure_pos_user,...
            'Color',BackgroundColor);
        
        
        
        for voc=1:voc_length
            rule_edit_user(voc,1)=uicontrol('Style', 'edit',...
                'String', '',...
                'BackgroundColor',BackgroundColor2,...
                'Position', [50,upos(voc),100,20]);
            uicontrol('Style','text', ...
                'HorizontalAlignment','left', ...
                'Position',[200,upos(voc),40,20], ...
                'String','-->',...
                'BackgroundColor',BackgroundColor);
            rule_edit_user(voc,2)=uicontrol('Style', 'edit',...
                'String', '',...
                'BackgroundColor',BackgroundColor2,...
                'Position', [250,upos(voc),100,20]);
        end
        
        
        button_done=uicontrol('Style', 'pushbutton', ...
            'Tag', 'button_quit',...
            'String', 'Done', ...
            'Units', 'pixels',...
            'Position', [100,10,100,20],...
            'Callback',@create_rule_function);
        
        button_done=uicontrol('Style', 'pushbutton', ...
            'Tag', 'button_quit',...
            'String', 'Save rules', ...
            'Units', 'pixels',...
            'Position', [250,10,130,20],...
            'Callback',@save_rule_function);
        
    end


    function save_rule_function(~,~)
        create_rule_function
        rule_name = inputdlg('Name of the new rule?',...
            'Name of the new rule?', [1 100]);
        cd(actpath)
        if exist('generator_user_rules.mat', 'file') == 2
            load('generator_user_rules.mat')
            ro=length(rule_def.name)+1;
        else
            ro=1;
        end
        if ruletype==1
            rt=' classic';
        elseif ruletype==2
            rt=' extended';
        end    
        rule_def.name{ro}=['USER ',rule_name{1}, rt];
        rule_def.values{ro}=size(rule,1);
        rule_def.start{ro}=rule(1,1);
        rule_def.rules{ro}=rule;
        rule_def.ruletype{ro}=ruletype;
        save('generator_user_rules.mat','rule_def');
        
        grammars=get_default_rules;
%         grammar_function
        
        set(GUI.grammar_type,'String', grammars.name)
        
        close(huser)
        
    end
    
    function create_rule_function(~,~)
        
        user_rule=cell(voc_length,2);
        for voc=1:voc_length
            for rrr=1:2
                %                 x=get(rule_edit_user(rrr,voc),'String');
                x=get(rule_edit_user((voc_length+1)-voc,rrr),'String');
                if isempty(x)
                    warndlg('All fields need to be filled in!')
                    
                elseif ruletype==1 && length(num2str(x))~=1 && rrr==1
                    errordlg('For the selected rule type "classic" only one character can be defined on the left hand side of the rules!','Input Error');
                else
                    user_rule{voc,rrr}=x;
                end
            end
        end
        rule=user_rule;
        
        
        close(huser)
        hfig;
        
        set(GUI.start_value,'String',rule{1,1});
        
        if ruletype==2
            select_replacetype
        end
    end

    function select_replacetype
        
        cfg.figure_pos_user=cfg.figure_pos;
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2-100;
        cfg.figure_pos_user(3)= 300;
        cfg.figure_pos_user(4)= 100;
        
        
        huser=figure('Tag', 'Define rules', 'Name', 'Replacement type', ...
            'Visible', 'on', 'Units', 'pixels', ...
            'MenuBar', 'none', 'ToolBar', 'none', ...
            'Resize', 'off', 'NumberTitle', 'off',...
            'Position', cfg.figure_pos_user,...
            'Color',BackgroundColor);
        
        uicontrol('Style','text', ...
            'HorizontalAlignment','left', ...
            'Position',[25,70,250,20], ...
            'String','Select type of replacement:',...
            'BackgroundColor',BackgroundColor);
        
        repgui.replace_type=uicontrol('Style', 'popupmenu',...
            'String', {'segmentwise','continous','continous (skip last n)'},...
            'Value', 2,...
            'Units', 'pixels', ...
            'Position', [25,50,250,20],...
            'BackgroundColor',BackgroundColor2);
        
        
        button_done=uicontrol('Style', 'pushbutton', ...
            'Tag', 'button_quit',...
            'String', 'Done', ...
            'Units', 'pixels',...
            'Position', [25,10,250,20],...
            'Callback',@get_rep_function);
    end

    function get_rep_function(~,~)
        cfg.reptype=get(repgui.replace_type,'Value');
        close(huser)
        hfig;
    end

    function back_function(~,~)
        close(hfig)
        hmenu;
        
    end

    function browse_button(~,~)
        
        folder_name = uigetdir('','Select output folder');
        set(GUI.output_folder,'String',folder_name)
    end

    function [grammars]=get_default_rules
        grammars.name{1}='Fibonacci';
        grammars.values{1}=2;
        grammars.start{1}='0';
        grammars.rules{1}={'0','1'; '1','10'}';
        
        grammars.name{2}='Algea';
        grammars.values{2}=2;
        grammars.start{2}='0';
        grammars.rules{2}={'0','1'; '01','0'}';
        
        grammars.name{3}='Thue-Morse';
        grammars.values{3}=2;
        grammars.start{3}='0';
        grammars.rules{3}={'0','1'; '01','10'}';
        
        grammars.name{4}='Feigenbaum';
        grammars.values{4}=2;
        grammars.start{4}='0';
        grammars.rules{4}={'0','1'; '11','01'}';
        
        grammars.name{5}='Cantor dust';
        grammars.values{5}=2;
        grammars.start{5}='0';
        grammars.rules{5}={'0','1'; '010','111'}';
        grammars.description{5}={'0: draw forward and 1: move forward'};
        
        grammars.name{6}='Pythagoras tree';
        grammars.values{6}=2;
        grammars.start{6}='0';
        grammars.rules{6}={'0','1'; '1[0]1','11'}';
        grammars.description{6}={'0: draw a line segment ending in a leaf ',...
            '1: draw a line segment',...
            '[: push position and angle, turn left 45 degrees',...
            ']: pop position and angle, turn right 45 degrees'};
        
        grammars.name{7}='Koch curve';
        grammars.values{7}=1;
        grammars.start{7}='1';
        grammars.rules{7}={'1'; '1+1-1-1+1'}';
        grammars.description{7}={'1 means draw forward,',...
            '+ means turn left 90 degree,',...
            '− means turn right 90 degree'};
        
        grammars.name{8}='Sierpinski triangle';
        grammars.values{8}=2;
        grammars.start{8}='0';
        grammars.rules{8}={'0','1'; '+1-0-1+','-0+1+0-'}';
        grammars.description{8}={'0 and 1 both mean draw forward,',...
            '+ means turn left by 60 degree,',...
            '− means turn right by 60 degree'};
        
        grammars.name{9}='User defined';
        grammars.values{9}=[];
        grammars.start{9}=[];
        grammars.rules{9}=[];
        
        try
            cd(actpath)
        end
        if exist('generator_user_rules.mat', 'file') == 2
            load('generator_user_rules.mat')
            for ii=1:length(rule_def.name)
                grammars.name{9+ii}=rule_def.name{ii};
                grammars.values{9+ii}=rule_def.values{ii};
                grammars.start{9+ii}=rule_def.start{ii}{1,1};
                grammars.rules{9+ii}=rule_def.rules{ii};
                grammars.ruletype{9+ii}=rule_def.ruletype{ii};
           end
        end
        
    end

    function figure_pos=calculate_figure_pos
        % calculate figure position at ~ center of screen
        % get actual screen resolution
        screen_size=get(0,'Screensize');
        % lower left corner horizontal position
        figure_pos(1)=screen_size(3)/2-200;
        % lower left corner vertical position
        figure_pos(2)=screen_size(4)/2-200;
        % horizontal size of the GUI
        figure_pos(3)=400;
        % vertical size of the GUI
        figure_pos(4)=460;
    end

    function quit_function(~,~)
        clear all
        clc
        close all
        fprintf(['\n',...
            '################################################\n',...
            '#                                              #\n',...
            '#           Thank you for using the            #\n',...
            '#                                              #\n',...
            '#         Lindenmayer Exploration Kit          #\n',...
            '#                                              #\n',...
            '#       Doug Saddy and Michael Lindner         #\n',...
            '#                                              #\n',...
            '################################################\n'])
        pause(3)
    end


    function output=cell2str(input)
        %         output = '';
        input = cellstr(input);
        output = [repmat(sprintf(['%s'], input{1:end-1}), ...
            1, ~isscalar(input)), ...
            sprintf('%s', input{end})];
    end


    function about_function(~,~)
        
        about_text={'Lindenmayer System Generator',...
            '',...
            'This tool is designed to generate Lindenmayer systems (grammar).',...
            '',...
            'USAGE:',...
            '',...
            'Select L-system',...
            'You can select a predefined system (e.g. Fibonacci), specify new',...
            'rule or load user defined rules.',...
            '','predefined rules',....
            'The rules for the predefined system will be presented in the ',...
            'fields under the drop-down menu after making your choice.',...
            '','User defined',...
            'You can also define a new grammar by selecting User defined.',...
            'Here you have two different options:',...
            '   1. The classical version where you can specify rule for ',...
            '      replacing one cahracter with a specific amount of other ',...
            '      characters.',...
            '   2. An extended version where you can specify rule for ',...
            '      replacing m number of characters with a specific amount of ',...
            '      other n number of chracters.',...
            'You can make your choice by pressing the appropriate button.',...
            'In both cases a new window will open to specify the number of',...
            'rules (replacements). A window, where you can specify the',...
            'rules will then open.',...
            'You can save the defined rules by pressing the "Save rules" button.',...
            'Then you can specify a name for the rule and it will be saved in a ',...
            'file called generator_user_rules.mat. The saved rules will appear in',...
            'the drop down menu with the prefix USER. The rules can be ',...
            'deleted by deleting the generator_user_rules.mat file. BUT BE ',...
            'AWARE that all rules will be deleted by doing this!',...
            '',...
            'In case of the extended replacement you can further select the',...
            'type of replacement which should be performed:',...
            'You have three options for types of replacement (how the rules',...
            'should be applied to the system):',...
            '1. segmentwise',...
            ' In the segmentwise replacement all vocabulars need to have the',...
            'same length. (e.g. 101, 111, 000, etc,). The grammar is then',...
            'cut into segments of the same length and the replacement',...
            'is then performed for each segment.',...
            '2, continuously',...
            ' In the continuous replacement the algorithm goes through the ',...
            'whole grammar elementwise and replaces the n elements from the',...
            'vocabulary with the m elements that you defined! Each element',...
            'will be checked and can be used more than once for a replacement!',...
            '',...
            'e.g. system:  001110110010011110010011110000',...
            '     rule: 111-->2 ; 110-->3 ; 100-->4',...
            '     results: 002310340040022340040022340000',...
            '',...
            '',...
            '3. continuously (skip last n)',...
            ' This type of replacement follows the same protocol as the one above, but',...
            'when identifying a match with your rule the next n-1 characters (length of',...
            'the vocabular) of the system are skipped. Here, each element will',...
            'only be used once for a replacement!',...
            '',...
            'e.g. system:  001110110010011110010011110000',...
            '     rule: 111-->2 ; 110-->3 ; 100-->4',...
            '     results: 0020304230423000',...
            '','',...
            'The start value for the grammar generation is by default: 0 for',...
            'for the predefined systems and for the user defined system it is',...
            'the value (lefthand side) of the first rule!',... 
            'But the start vlaue can be changes changed individually.',...
            'IMPORTANT: The values in the "start values" field',...
            'need to be included within the rules you define!',...
            '',...
            'With the number of recursions you can specify how often the',...
            'rules should be used iteratively.',...
            '',...
            'You need to specify an output folder by typing in a path or',...
            'by using the browse button.',...
            'Furthermore, you can specify an output file prefix and the type of',...
            'output which should be stored. Either a Matlab .mat file,',...
            'a text file, or both are valid:',...
            'In the case of a .mat file, three variables are stored: a cell',...
            'with the grammar of each iteration, the rule and a vector with the',...
            'length of each iteration.',...
            'In the case of a .txt file, three output files are stored. One with',...
            'the grammar, one including the length of each iteration and one',...
            'containing the rule.',...
            '',...
            'After setting up all parameters, you simply need to press the',...
            'generate grammar button.',...
            '',...
            'After setting up all parameters, you simply need to press the',...
            'Modify L-system button.',...
            '',...
            'LSEx.m by Michael Lindner and Jamesd Douglas Saddy is licensed,',...
            'under CC BY 4.0',...
            '',...
            'This program is distributed in the hope that it will be useful,',...
            'but WITHOUT ANY WARRANTY;',...
            '',...
            'by Michael Lindner and Doug Saddy',...
            'l-s-ex@gmx.co.uk',...
            'University of Reading, 2017',...
            'Center for Integrative Neuroscience and Neurodynamics',...
            'https://www.reading.ac.uk/cinn/cinn-home.aspx'};
        
        f=figure('menu','none','toolbar','none','name',...
            'Example script','NumberTitle','Off');
        hPan = uipanel(f,'Units','normalized');
        uicontrol(hPan, 'Style','listbox', ...
            'HorizontalAlignment','left', ...
            'Units','normalized', 'Position',[0 .2 1 .8], ...
            'String',about_text);
        
        
        btn=uicontrol('Style','pushbutton','String','Close',...
            'position',[10 10 200 20],...
            'Callback',@close_about);
        
        function close_about(hObject,callbackdata)
            close(f)
        end
    end

end







