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

import java.awt.Graphics;

public class TextSelectableProofItem extends TextSelectableItem {
    public TextSelectableProofItem(JapeCanvas canvas, int x, int y, byte fontnum,
                                   String annottext, String printtext) {
        super(canvas, x, y, fontnum, annottext, printtext);
    }

    boolean drawGrey = false;

    public void paint(Graphics g) {
        if (drawGrey) {
            if (paint_tracing)
                System.err.println("painting grey text item at "+getX()+","+getY());
            g.setColor(Preferences.GreyTextColour); g.setFont(getFont());
            g.drawChars(printchars, 0, printchars.length, 0, dimension.ascent);
        }
        else
            super.paint(g);
    }
}
