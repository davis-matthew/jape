//
//  Alert.java
//  japeserver
//
//  Created by Richard Bornat on Tue Sep 03 2002.
//  Copyleft 2002 Richard Bornat & Bernard Sufrin. Proper GPL text to be inserted
//

import java.awt.Component;
import java.awt.Container;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.util.Vector;

public class Alert {
    // oh the ceaseless dance of interface conversions ..
    public static final int Info = JOptionPane.INFORMATION_MESSAGE;
    public static final int Warning = JOptionPane.WARNING_MESSAGE;
    public static final int Error = JOptionPane.ERROR_MESSAGE;
    public static final int Question = JOptionPane.QUESTION_MESSAGE;
    
    private static int messagekind(int severity) throws ProtocolError {
        switch (severity) {
          case 0: return Info;
          case 1: return Warning;
          case 2: return Error;
          case 3: return Question;
          default: throw (new ProtocolError(severity+" should be message severity (0:info, 1:warning, 2:error, 3: question)"));
        }
    }
    
    private static JLabel makeLabel(String s) {
        JLabel l = new JLabel(s);
        if (japeserver.onMacOS) {
            JapeFont.setComponentFont(l);
        }
        return l;
    }
    
    // this is where we will eventually process multi-line strings and 
    // handle aspect ratio
    private static JLabel[] makeMessage(String s) {
        JLabel l = makeLabel(s);
        TextDimension m = JapeFont.measure(l, s);
        System.err.println("alert message stats: "+m+"--\""+s+"\"");
        if (m.width>japeserver.screenBounds.width*3/4) {
            String[] split = JapeFont.minwaste(l, s, japeserver.screenBounds.width/2);
            System.err.println("splits into :--");
            for (int i=0; i<split.length; i++) {
                System.err.println("    "+i+": "+JapeFont.measure(l,split[i])+"--\""+split[i]+"\"");
            }
            JLabel[] ls = new JLabel[split.length];
            for (int i=0; i<ls.length; i++)
                ls[i] = makeLabel(split[i]);
            return ls;
        }
        else {
            JLabel[] ls = { l };
            return ls;
        }
    }
    
    public static void showAlert(int messagekind, String message) {
        // I don't think this needs invokeLater ...
        JOptionPane.showMessageDialog(null,makeMessage(message),null,messagekind);
    }
    
    static String quit="Quit", cont="Continue";

    public static void showErrorAlert(String message) {
        String[] buttons = { quit, cont };
        int reply = JOptionPane.showOptionDialog(
                        null, makeMessage(message), "GUI error", 0, Error,
                        null, buttons, quit);
        if (reply==0)
            System.exit(2);
    }
    
    // this doesn't deal with fonts yet ... I think we have to make a Component (sigh)
    // and I haven't worked out what to do with defaultbutton ...
    public static void newAlert (Vector buttons, int severity, String message, int defaultbutton) 
    throws ProtocolError {
        if (buttons.size()==1 && ((String)buttons.get(0)).equals("OK")) {
            showAlert(messagekind(severity), message);
        }
        else {
            String s = "can't yet show alert: [";
            for (int i=0; i<buttons.size(); i++) 
                s=s+(i==0?"\"":",\"")+((String)buttons.get(i))+"\"";
            showAlert(Error, s+" "+severity+" \""+message+"\" "+defaultbutton);
        }
    }
}
