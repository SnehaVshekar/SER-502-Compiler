import java.io.*;

import static java.lang.System.*;

import java.util.*;



public class Runtime 
{
	public static Deque<String> thisfunction = new ArrayDeque<String>();
	public static HashMap<String, Double> hmglobalvalues = new HashMap<String, Double>();
	public static HashMap<String, Boolean> booleanhmglobalvalues = new HashMap<String, Boolean>();
	public static HashMap<String, String> stringhmglobalvalues = new HashMap<String, String>();
	public static HashMap<String, Stack<Integer>> stackhmglobalvalues = new HashMap<String, Stack<Integer>>();
	public static HashMap<String, Deque<Integer>> functions= new HashMap<String,Deque<Integer>>();
	public static Deque<Integer> functionstack = new ArrayDeque<Integer>();

	public static char[] temp = new char[400];
	public static int tokenlength = 1;
	public static String code = "";
	public static String[] tokenList;
	public static String[] operationsList;
	public static String[] valuesList;
	
	public static void main(String[] args) throws IOException 
	{
	
		int p = 0 ;
		int q = 0;
		
		try
		{
			FileInputStream bytecode = new FileInputStream(args[0]);
			int rd = bytecode.read();
			char ch = (char)rd;
			temp[0]= ch;
			
			//reading each character and associating as a token
			while(((rd = bytecode.read()) != -1))
			{			
				ch = (char)rd;
				temp[tokenlength]= ch;
				tokenlength += 1;
			}
			
			code = String.valueOf(temp);
			code = code.substring(0,tokenlength-1);
			tokenList = code.split("\\s+");
			operationsList = new String[tokenlength];
			valuesList  = new String[tokenlength];
			
			//associating each token and its respective 3 letter opcodes from intermediate code
				while(!tokenList[p].equals("end"))
				{ 
					if ((tokenList[p].equals("not"))||(tokenList[p].equals("or"))||(tokenList[p].equals("and"))||(tokenList[p].equals("str"))||(tokenList[p].equals("ass"))||(tokenList[p].equals("les"))||(tokenList[p].equals("plu"))||(tokenList[p].equals("sub")) ||(tokenList[p].equals("mul")) ||(tokenList[p].equals("div")) ||(tokenList[p].equals("put")) || (tokenList[p].equals("get"))|| (tokenList[p].equals("bne")) || (tokenList[p].equals("beq"))|| (tokenList[p].equals("dsp"))|| (tokenList[p].equals("grt"))|| (tokenList[p].equals("inp")))
					{
						operationsList[q]= tokenList[p];
						q += 1;
					}
					else 
					{
						valuesList[q-1]= tokenList[p];
					      //j += 1;
					}
									
					p += 1;
				}
				
				operationsList[q]=tokenList[p];
				operationsList = Arrays.copyOf(operationsList,q+1);
				valuesList = Arrays.copyOf(valuesList,q+1);
		}
		catch (IOException e)
		{
			out.println("ERROR1");
		}
			
		func(0,q+1);
			
	}
	
	@SuppressWarnings("null")
	public static void func(int a, int b)
	{
		
				Deque<Double> stack = new ArrayDeque<Double>();
				Deque<Boolean> booleanstack = new ArrayDeque<Boolean>();
				Deque<String> stringstack = new ArrayDeque<String>();

				HashMap<String, Double> hmvalues = new HashMap<String, Double>();
				HashMap<String, Boolean> booleanhmvalues = new HashMap<String, Boolean>();
				HashMap<String, String> stringhmvalues = new HashMap<String, String>();

				HashMap<String, Stack<Integer>>  stackhmvalues = new HashMap<String, Stack<Integer>>();
				String[] operations = Arrays.copyOfRange(operationsList,a,b );
				String[] values = Arrays.copyOfRange(valuesList,a,b );
				
				//pushing each value into the stack as and when we read the 3 letter opcodes
				for ( int i=0; i<b-a;i++)
				{
					//reading input from user
					if (operations[i].equals("inp"))
					{   
						Scanner sc = new Scanner(System.in);
						out.println("Enter Value");
						double input = sc.nextDouble();
						stack.push(input);;
					}
					//if variable is a string
					if (operations[i].equals("str")) 
					{

						stringstack.push(values[i]);
					}
					//putting values into the variables
					if ((operations[i].equals("put")&&((stack.isEmpty()==false)||(booleanstack.isEmpty()==false)||(stringstack.isEmpty()==false)))) 
					{   
						
						if((thisfunction.isEmpty())&&(stack.peek()!=null)) 
						{
							hmglobalvalues.put(values[i], stack.pop());
						} 
						else if ((thisfunction.isEmpty())&&(booleanstack.peek()!=null)) 
						{
							booleanhmglobalvalues.put(values[i], booleanstack.pop());
						} 
						else if ((!thisfunction.isEmpty())&&(booleanstack.peek()!=null)) 
						{
							booleanhmvalues.put(values[i], booleanstack.pop());
						} 
						else if(hmglobalvalues.get(values[i])!=null)
						{
							hmglobalvalues.put(values[i],stack.pop());
						}  
						else if ((thisfunction.isEmpty())&&(stringstack.peek()!=null)) 
						{
							stringhmglobalvalues.put(values[i], stringstack.pop());
						} 
						else if ((!thisfunction.isEmpty())&&(stringstack.peek()!=null)) 
						{
							stringhmvalues.put(values[i], stringstack.pop());
						} 
						else 
						{
							hmvalues.put(values[i],stack.pop());
						}
					}
					//loading the values into the variable	
					if (operations[i].equals("get"))	
					{   
						boolean doubleornot = true;
						try
						{ 
							Double.parseDouble(values[i]); 
						}
						catch(NumberFormatException e) 
						{
							doubleornot = false;
						}
						if(doubleornot==false)
						{
							if(hmglobalvalues.get(values[i])!=null)
							{
								stack.push(hmglobalvalues.get(values[i]));
							}
							else if(hmvalues.get(values[i])!=null)
							{
								stack.push(hmvalues.get(values[i]));
							}
							else if(hmglobalvalues.get(values[i])!=null)
							{
								stack.push(hmglobalvalues.get(values[i]));
							}
							else if (booleanhmvalues.get(values[i])!=null)
							{
								booleanstack.push(booleanhmvalues.get(values[i]));
							}
							else if (values[i].equals("true"))
							{
								booleanstack.push(true);
							}
							else if (values[i].equals("false"))
							{
								booleanstack.push(false);
							}
							else if ((booleanhmglobalvalues.get(values[i])!=null))
							{
								booleanstack.push(booleanhmglobalvalues.get(values[i]));
							}
							else if(stringhmglobalvalues.get(values[i])!=null) 
							{
								stringstack.push(stringhmglobalvalues.get(values[i]));
							} 
							else if(stringhmvalues.get(values[i])!=null) 
							{
								stringstack.push(stringhmvalues.get(values[i]));
							}  
							else
							{
								out.println("Error on load!");
							}
						}
						
						if(doubleornot==true)
						{
							stack.push(Double.parseDouble(values[i]));
						}						
					}
					//opcode to display the value
					if (operations[i].equals("dsp"))
					{
						if(stack.isEmpty()==false)
						{
							out.println(stack.pop());
						}
						else if(booleanstack.isEmpty()==false)
						{
							out.println(booleanstack.pop());
						}
						else if(stringstack.isEmpty()==false) 
						{
							String s = stringstack.pop();
							out.println(s.substring(1,s.length()-1));
						}
					}
					//opcode for addition
					if ((operations[i].equals("plu"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						stack.push(left+right);
					}
					//opcode for subtraction					
					if ((operations[i].equals("sub"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						stack.push(left-right);
					}
					//opcode for multiplication				
					if ((operations[i].equals("mul"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						stack.push(left*right);
					}
					//opcode for division					
					if ((operations[i].equals("div"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						stack.push(left/right);
					}
					//opcode for checking if greater than 					
					if ((operations[i].equals("grt"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						if (left>right)
						{
							stack.push(1.0);
							//out.println("grt");
						}
						else
						{
							stack.push(0.0);
							//out.println("not grt");
						}
					}
					//opcode for checking if lesser than 										
					if ((operations[i].equals("les"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						if (left<right)
						{
							stack.push(1.0);
							//out.println("grt");
						}
						else
						{
							stack.push(0.0);
							//out.println("not grt");
						}
					}
					//opcode for checking logical and					
					if ((operations[i].equals("and"))&&(booleanstack.isEmpty()==false)) 
					{

						Boolean right = booleanstack.pop();
						Boolean left  = booleanstack.pop();

						if (left && right) 
						{
							booleanstack.push(true);
						} 
						else 
						{
							booleanstack.push(false);
						}
					}
					//opcode for checking logical or
					if ((operations[i].equals("or"))&&(booleanstack.isEmpty()==false)) 
					{

						Boolean right = booleanstack.pop();
						Boolean left  = booleanstack.pop();

						if (left || right) 
						{
							booleanstack.push(true);
						} 
						else 
						{
							booleanstack.push(false);
						}
					}
					//opcode for checking logical not
					if ((operations[i].equals("not"))&&(booleanstack.isEmpty()==false)) 
					{

						Boolean left  = booleanstack.pop();

						if (!left) 
						{
							booleanstack.push(true);
						} 
						else 
						{
							booleanstack.push(false);
						}
					}
					//opcode for checking assignment operator
					if ((operations[i].equals("ass"))&&(stack.isEmpty()==false))
					{
						double right=stack.pop();
						double left=stack.pop();
						if (left==right)
						{
							stack.push(1.0);
							//out.println("grt");
						}
						else
						{
							stack.push(0.0);
							//out.println("not grt");
						}
					}
					//opcode to check if it branches not equal to which means if it is false it should jump to the next line
					if ((operations[i].equals("bne"))&&(stack.isEmpty()==false))
					{
						if((stack.peek()==0.0)&&(thisfunction.isEmpty()))
						{
							i = Integer.parseInt(values[i])-1;
							//out.println("false and jump to line "+i);
							stack.pop();
						}
						else if((stack.peek()==0.0)&&(!thisfunction.isEmpty()))
						{
							i = Integer.parseInt(values[i])-a;
							stack.pop();
							if(i>b-a-1){
								i=b-a-1;
							}
						}
						else
						{
							stack.pop();
						}
					}
					//opcode to check if it branch equals to which means if it is true it should jump to the next line
					if ((operations[i].equals("beq"))&&(stack.isEmpty()==false))
					{
						if(stack.peek()==1.0)
						{
							i = Integer.parseInt(values[i])-1;
							//out.println("true and jump to line "+i);
							stack.pop();
						}
					}
				}			
	}
	

}