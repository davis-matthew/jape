/**
        Represents 
                members: set(0..size-1)
        where
                s[i]=true <=> i in members
*/

public class Set
{ boolean[] s    = null; 
  int       size = 0;

  /**
        Construct (a representation of) an empty subset of 0..size-1
  */
  public Set(int size) { this.size = size; s = new boolean[size]; }
  
  public String toString()
  { int[] r = runs();
    String s = "Set: ";
    for (int i=0; i<r.length; i++) s = s + " " + r[i];
    return s;
  }

  /**
        returns 
                runs: seq(Nat)
        where
           for all n in 0..#runs/2
                runs(2n)   .. runs(2n+1)-1 disjoint from members 
                runs(2n+1) .. runs(2n+2)-1 subset of     members 
  */
  public int[] runs() 
  { int count = 0;
    boolean state=false;
    for (int i=0; i<size; i++) if (s[i]!=state) { count++; state=s[i]; }
    int[] r = new int[count];
    count = 0;
    state = false;
    for (int i=0; i<size; i++) 
    if (s[i]!=state) { r[count]=i; count++; state=s[i]; }
    return r;
  }

  /** 
        returns #members
  */
  public int count()
  { int n=0;
    for (int i=0; i<size; i++) if (s[i]) n++;
    return n;
  }

  /** 
        members := members union (left..right-1)
  */
  public void add(int left, int right)
  { for (int i=left; i<right; i++) s[i]=true; }
  
  /** 
        members := members - (left..right-1)
  */
  public void rem(int left, int right)
  { for (int i=left; i<right; i++) s[i]=false; }
  
  /** 
        members := members - (members inter S) union (S - members)
        where 
          S = left..right-1
  */
  public void inv(int left, int right)
  { for (int i=left; i<right; i++) s[i]= !s[i]; }
  
  /** 
        returns (left..right-1) subset members
  */
  public boolean subset(int left, int right)
  { for (int i=left; i<right; i++) 
        if (!s[i]) return false;
    return true;
  }
  
  /** 
        members := {}
  */
  public void clear()
  { for (int i=0; i<size; i++) s[i]=false; }
  
  /*
  public static void main(String[] arg)
  { Set s = new Set(50);
    for (int i=0; i<arg.length; i=i+2) 
      s.add(Integer.parseInt(arg[i]), Integer.parseInt(arg[i+1]));
    System.err.println(s.toString());
  }
  */
}




