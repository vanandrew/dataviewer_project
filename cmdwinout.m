function [cwText] = cmdwinout()
%CMDWINOUT - Returns output from command window
    if ~isdeployed
        disp('#');
        jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
        jCmdWin = jDesktop.getClient('Command Window');
        jTextArea = jCmdWin.getComponent(0).getViewport.getView;
        cwText = strsplit(char(jTextArea.getText),'#');
    else
        cwText = 'Command History output not supported on MCR';
    end
end