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
import java.awt.event.MouseEvent;

public class ProofCanvas extends JapeCanvas {
    static final byte BoxStyle = 0,
                      TreeStyle = 1;

    // bit selectors for selections
    static final byte HypSel       = 1<<0,
                      ConcSel      = 1<<1,
                      ReasonSel    = 1<<2;

    public ProofCanvas() { super(); }

    protected void selectionMade(SelectableTextItem item, MouseEvent event, byte selkind) {
        switch (selkind) {
            case HypSel:
                // policy at present is that HypSel kills all ReasonSels,
                // and all other HypSels unless the shift key is down
                killSelections((byte)(ReasonSel | (event.isShiftDown() ? NoSel : HypSel)));
                break;
            case ConcSel:
                // ConcSel kills all ReasonSels and all other ConcSels
                killSelections((byte)(ReasonSel | ConcSel));
                break;
            case ReasonSel:
                // ReasonSel kills all other selections
                killSelections((byte)0xFF);
                break;
            default:
                Alert.abort("ProofCanvas.selectionMade selkind="+selkind);
        }
        item.select(selkind); 
    }

    protected void textselectionMade(SelectableTextItem item, MouseEvent e) {
        System.err.println("no ProofCanvas support for text selections yet");
    }

    public String getTextSelections() {
        return ""; // for now
    }

    // these are not yet coming out in time order ...
    // reply always ends with a blank line
    public String getSelections() {
        String s = null;
        int nc = child.getComponentCount(); // oh dear ...
        for (int i=0; i<nc; i++) {
            Component c = child.getComponent(i); // oh dear ...
            if (c instanceof SelectableTextItem) {
                byte selclass;
                SelectableTextItem sti = (SelectableTextItem)c;
                if (sti.selectionRect==null)
                    continue;
                else
                switch (sti.selectionRect.selkind) {
                    case HypSel   : selclass = TextItem.HypKind; break;
                    case ConcSel  : selclass = TextItem.ConcKind; break;
                    case ReasonSel: selclass = TextItem.ReasonKind; break;
                    default       : Alert.abort("ProofCanvas.reportSelections selkind="+sti.selectionRect.selkind);
                                    selclass=0; // shut up compiler
                }
                String s1 = sti.idX+" "+sti.idY+" "+selclass+"\n";
                if (s==null)
                    s=s1;
                else
                    s=s+s1;
            }
        }
        return s==null ? "" : s; 
    }
}
