/* 
    $Id$

    Copyright � 2002 Richard Bornat & Bernard Sufrin
     
        richard@bornat.me.uk
        sufrin@comlab.ox.ac.uk

    This file is part of japeserver, which is part of jape.

    Jape is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Jape is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with jape; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    (or look at http://www.gnu.org).
*/

import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Rectangle;
import java.awt.Toolkit;

import java.io.File;

import java.util.Vector;

public class japeserver implements DebugConstants {

    private static boolean tracing = true;

    private static String[] operators;
    
    public static void setoperators(String[] _operators) {
        operators=_operators;
    }
    
    public static void handleAbout() {
        AboutBox.showAboutBox();
    }

    private static boolean quitsent=false;
    
    public static void handleQuit() {
        if (!quitsent) {
            quitsent = true;
            Reply.sendCOMMAND("quit");
        }
        else
            Alert.showErrorAlert("The engine isn't responding!");
    }

    public static void dontQuit() {
        quitsent = false;
    }

    public static void handlePrefs() {
        Alert.showAlert(Alert.Info, "Preferences item selected in menu");
    }
    
    private static String theorypath, theory, ext, title, iconname,
        viewpath, pviewpath, proofpath;

    public static boolean onMacOS, useScreenMenuBar;
    public static Rectangle screenBounds;
    
    public static void main(String args[]) {
        // since platform independence seems not yet to have been achieved ...
        onMacOS = notice_MacOSX && (System.getProperty("mrj.version")!=null);
        // oh calamity!
        if (onMacOS) { // deal with the double-bounce menu checkbox bug
            String s = System.getProperty("com.apple.macos.useScreenMenuBar");
            JapeMenu.CheckboxDoubleBounce = s!=null && s.equals("true");
        }
        else
            JapeMenu.CheckboxDoubleBounce = false; 
        useScreenMenuBar=false;
        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice gd = ge.getDefaultScreenDevice();
        GraphicsConfiguration[] gc = gd.getConfigurations();
        if (gc.length>=1) {
            screenBounds = gc[0].getBounds(); // I hope and truly believe that 0 is the default
        }
        else
            Alert.abort("no GraphicsConfiguration!");
        
        // #
        // # Set up various paths
        // # 
        // # Assumption is:
        // #   
        // #   args=[path to server, ... command invoking server ..., --, first arg of command]
        // #
        if (args.length>=4 && args[args.length-2].equals("--") && args[args.length-1].charAt(0)!='-') {
            theorypath = args[args.length-1];
            File theoryfile = new File(theorypath);
            // there must be a way of doing this in the library ..
            String name = theoryfile.getName();
            int i;
            for (i = name.length()-1; i>=0; i--) 
                if (name.charAt(i)=='.') 
                    break;
            if (i<0) {
                theory = name; ext=null;
            }
            else
            if (i==0) {
                // assume it was a directory
                // this.theorypath=os.path.join(this.theorypath, "")
                // this.title(this.appname+' in '+this.theorypath)
                // this.iconname(this.appname+' in '+this.theorypath)
                theory = ext = null;
            }
            else {
                theory = name.substring(0,i-1); ext = name.substring(i+1, name.length()-1);
                // if ext in ['.j', '.jt', '.jape']:
                //     this.wm_update(this.theorypath)
            }
        }
        
        viewpath       = null;
        pviewpath      = null;
        proofpath      = null;
        theory         = null;
        
        
        Toolkit.getDefaultToolkit(); // what for?

        JapeMenu.init();

        LocalSettings l = new LocalSettings();

        new Dispatcher().start();
        
        if (tracing)
            System.err.println("japeserver initialised");
    }

    // for debugging
    public static void showContainer(Container pane, String prefix) {
        for (int i=0; i<pane.getComponentCount(); i++) {
            Component c = pane.getComponent(i);
            String label = prefix==null ? ""+i : prefix+"."+i;
            System.err.println(label+": "+c);
            if (c instanceof Container)
                showContainer((Container)c, label);
        }
    }
}
