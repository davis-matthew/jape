// not happy about the way I get a border round the logo

/* 
    $Id$

    Copyright � 2003 Richard Bornat & Bernard Sufrin
     
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

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JFrame;
import javax.swing.JMenuBar;
import javax.swing.SwingConstants;

public class SurrogateWindow extends JapeWindow {
    static final String message = "Jape!";
    private Font font = new Font("serif", Font.ITALIC+Font.BOLD, 36);
    private ImageIcon logoIcon = new ImageIcon(Images.getImage("japelogo.gif"));

    public SurrogateWindow() {
        super("japeserver");
        getContentPane().setBackground(Color.white);
        JLabel logo = new JLabel("� Richard Bornat and Bernard Sufrin 1991-2002", logoIcon, SwingConstants.CENTER);
        logo.setVerticalTextPosition(SwingConstants.BOTTOM);
        logo.setHorizontalTextPosition(SwingConstants.CENTER);
        getContentPane().add(logo, BorderLayout.CENTER);
        JLabel link = new JLabel("Freeware under GPL licence: see www.jape.org.uk");
        getContentPane().add(link, BorderLayout.SOUTH); // It ought to be in the middle ...
        pack();
        setLocation(japeserver.screenBounds.width/2-getWidth()/2,
                    japeserver.screenBounds.height/2-getHeight()/2);
        setSize(getWidth()+60, getHeight()+60);
        setBar(); // by experiment, seems to be necessary before setVisible
        // no setVisible here ...

        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (Alert.askOKCancel(SurrogateWindow.this, "Quit Jape?")==Alert.OK)
                    japeserver.handleQuit();
            }
        });
    }
}

