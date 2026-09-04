`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 11:10:33 AM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
   clk,reset,PC_in,PC_out
    );
    input clk,reset;
    input[31:0] PC_in;
    output reg[31:0] PC_out;
    
    always@(posedge clk or posedge reset)
    begin
    if(reset)
        PC_out <= 32'b00;
     else
       PC_out <= PC_in;
    end
    
endmodule

//PC + 4
module PCplus4(fromPC,nextoPC);

input [31:0] fromPC;
output [31:0] nextoPC;

assign nextoPC  = 4 + fromPC;
 
endmodule


//instruction memory

module instruction_mem(clk,reset,read_address,instruction_out);

input clk,reset;
input [31:0] read_address;
output  [31:0] instruction_out;
reg [31:0] I_mem[63:0];     //64 location with width of 32 
integer k;
assign instruction_out = I_mem[read_address[31:2]];
always@(posedge clk or posedge reset)
begin
if(reset)
     begin
         for(k = 0 ; k < 64 ; k = k + 1) begin
         I_mem[k] <= 32'b00;
         end
      end
      else begin
      //R-type
      I_mem[0]= 32'b00000000000000000000000000000000; //no operation
      I_mem[1]= 32'b0000000_11001_10000_000_01101_0110011; // add x13 , x16 , x25
      I_mem[2]= 32'b0100000_00011_01000_000_00101_0110011; //sub x5 , x8 , x3
      I_mem[3]= 32'b0000000_00011_00010_111_00001_0110011;  //and x1 , x2 , x3
      I_mem[4]= 32'b0000000_00101_00011_110_00100_0110011;  //or x1 , x2 , x3
      //I-type
      I_mem[5]= 32'b000000000011_10101_000_10110_0010011; //addi x22,x21,3
      I_mem[6]= 32'b000000000001_01000_110_01001_0010011;  //ori x9,x8,1
      //L-type   
      I_mem[7]= 32'b000000001111_00101_010_01000_0000011; //lw x8,15(x5)
      I_mem[8] = 32'b000000000011_00011_010_01001_0000011; // lw x9,3(x3)
      //s-type
      I_mem[9]= 32'b0000000_01111_00101_010_01100_0100011; //sw x15,12(x5)
      I_mem[10]= 32'b0000000_01110_00110_010_01010_0100011; //sw x14,10(x6)
      //SB-type
      I_mem[11] = 32'h00948663; //beq x9 , x9, 12    
 end
 end
 endmodule
 
 //register file
 
 module reg_file(clk,reset,regwrite,rs1,rs2,rd,write_data,read_data1,read_data2);
 
input clk,reset,regwrite;
input [4:0] rs1,rs2,rd;
input [31:0] write_data;
output [31:0] read_data1,read_data2;
integer k;
reg[31:0] register[31:0];
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        register[0]  <= 0;
        register[1]  <= 4;
        register[2]  <= 3;
        register[3]  <= 2;
        register[4]  <= 5;
        register[5]  <= 9;
        register[6]  <= 10;
        register[7]  <= 20;
        register[8]  <= 20;
        register[9]  <= 30;
        register[10] <= 40;
        register[11] <= 50;
        register[12] <= 60;
        register[13] <= 70;
        register[14] <= 4;
        register[15] <= 90;
        register[16] <= 40;
        register[17] <= 15;
        register[18] <= 12;
        register[19] <= 17;
        register[20] <= 54;
        register[21] <= 66;
        register[22] <= 43;
        register[23] <= 55;
        register[24] <= 67;
        register[25] <= 65;
        register[26] <= 90;
        register[27] <= 34;
        register[28] <= 11;
        register[29] <= 34;
        register[30] <= 50;
        register[31] <= 66;
    end
    else if(regwrite)
    begin
        register[rd] <= write_data;
    end
end
       
           assign read_data1 = register[rs1];
           assign read_data2 = register[rs2];
endmodule


//immediate generator

module immgen(opcode , instruction , immext);

input  [6:0] opcode;
input [31:0] instruction;
output reg [31:0] immext;

always @(*)
begin
    case(opcode)

        // I-type: ADDI, ORI
        7'b0010011:
            immext = {{20{instruction[31]}}, instruction[31:20]};

        // LW
        7'b0000011:
            immext = {{20{instruction[31]}}, instruction[31:20]};

        // SW
        7'b0100011:
            immext = {{20{instruction[31]}},
                      instruction[31:25],
                      instruction[11:7]};

        // BEQ
        7'b1100011:
            immext = {{19{instruction[31]}},
                      instruction[31],
                      instruction[30:25],
                      instruction[11:8],
                      1'b0};

        default:
            immext = 32'b0;

    endcase
end
 endmodule
 //control unit
 module control_unit(instruction,branch,memread,memtoreg,aluop,memwrite,alusrc,regwrite);
 input [6:0] instruction;
 output reg branch,memread,memtoreg,memwrite,alusrc,regwrite;
 output reg [1:0] aluop;
 
 always@(*)
 begin
     case(instruction)

    7'b0110011:
        {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
        = 8'b001000_10;

    7'b0000011:
        {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
        = 8'b111000_00;

    7'b0100011:
        {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
        = 8'b100010_00;

    7'b1100011:
        {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
        = 8'b000001_01;

    7'b0010011:
        {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
        = 8'b101000_00;
    default:
            {alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop}
            = 8'b00000000;

endcase
      end
endmodule

//ALU
module alu_unit(A,B,Control_in,ALU_result,zero);
input [31:0] A,B;
input [3:0] Control_in;
output reg zero;
output reg [31:0] ALU_result;

always@(Control_in or A or B)
begin
   case(Control_in)
   4'b0000 : begin
   zero <= 0;
   ALU_result <= A & B;
   end
   4'b0001 : begin
   zero <= 0;
   ALU_result <= A | B;
   end
   4'b0010 : begin
   zero <= 0;
   ALU_result <= A + B;
   end
   4'b0110 : begin
   if(A==B) 
   zero <= 1;
   else
   zero <= 0;
   ALU_result <= A - B;
   end
   endcase
   end
   endmodule
   
   //alu control
   
   module alu_control(aluop, fun7, fun3, control_out);

input fun7;
input [2:0] fun3;
input [1:0] aluop;
output reg [3:0] control_out;

always @(*)
begin

    case(aluop)

        2'b00: begin
            control_out = 4'b0010; // ADD
        end

        2'b01: begin
            control_out = 4'b0110; // SUB
        end

        2'b10: begin

            case({fun7,fun3})

                4'b0000:
                    control_out = 4'b0010; // ADD

                4'b1000:
                    control_out = 4'b0110; // SUB

                4'b0111:
                    control_out = 4'b0000; // AND

                4'b0110:
                    control_out = 4'b0001; // OR

                default:
                    control_out = 4'b0010;

            endcase
        end

        default:
            control_out = 4'b0010;

    endcase
end

endmodule
//data memory
module data_memory(clk,reset,memwrite,mem_read,read_address,write_data,memdata_out);
input  clk,reset,memwrite,mem_read;
input [31:0] read_address,write_data;
output [31:0]  memdata_out;
integer k;
reg [31:0] D_memory [63:0];

always@(posedge clk or posedge reset)
begin
if(reset)
    begin
       for(k = 0;k < 64 ; k = k + 1)
       begin
       D_memory[k] <= 32'b00;
       end
       
       end
       else if(memwrite) begin
          D_memory[read_address] <= write_data;
          end
          end
          assign memdata_out = (mem_read) ? D_memory[read_address] : 32'b00;
          
      endmodule
      
//multiplexer

module mux1(sel1 ,A1,B1,mux1_out);
input sel1;
input [31:0] A1,B1;
output [31:0] mux1_out;

assign mux1_out = (sel1 == 1'b0) ? A1 : B1;
endmodule

module mux2(sel2 ,A2,B2,mux2_out);
input sel2;
input [31:0] A2,B2;
output [31:0] mux2_out;

assign mux2_out = (sel2 == 1'b0) ? A2 : B2;
endmodule

module mux3(sel3 ,A3,B3,mux3_out);
input sel3;
input [31:0] A3,B3;
output [31:0] mux3_out;

assign mux3_out = (sel3 == 1'b0) ? A3 : B3;
endmodule

//and logic 
module and_logic(branch,zero,and_out);

input branch,zero;
output and_out;

assign and_out = branch & zero;
endmodule

//adder
module adder(in_1,in_2,sum_out);

input [31:0] in_1,in_2;
output [31:0] sum_out;

assign sum_out = in_1 + in_2;

endmodule

//all instantiate here

module top(clk,reset);
input clk,reset;
wire[31:0] PC_top,instruction_top,rd1_top,rd2_top,immext_top,mux1_top,sumout_top,nextoPC_top,PCin_top,address_top,memdata_top,writeback_top;
wire regewrite_top,alusrc_top,zero_top,branch_top,sel2_top,memtoreg_top,memwrite_top,memread_top;
wire [1:0] aluop_top;
wire [3:0] control_top;

//program counter
program_counter PC(
    .clk(clk),
    .reset(reset),
    .PC_in(PCin_top),
    .PC_out(PC_top)
);

//pc4 adder
PCplus4 pc_adder(.fromPC(PC_top),.nextoPC(nextoPC_top));

//instruction memory
instruction_mem inst_memory(.clk(clk),.reset(reset),.read_address(PC_top),.instruction_out(instruction_top));

 //register file
reg_file reg_file(.clk(clk),.reset(reset),.regwrite(regewrite_top),.rs1(instruction_top[19:15]),.rs2(instruction_top[24:20]),.rd(instruction_top[11:7]),.write_data(writeback_top),.read_data1(rd1_top),.read_data2(rd2_top));

 //immediate generator
immgen immgen(.opcode(instruction_top[6:0]) , .instruction(instruction_top) , .immext(immext_top));

 //control unit
control_unit control_unit(.instruction(instruction_top[6:0]),.branch(branch_top),.memread(memread_top),.memtoreg(memtoreg_top),.aluop( aluop_top),.memwrite(memwrite_top),.alusrc(alusrc_top),.regwrite(regewrite_top));

 //alu control unit
alu_control alu_control(.aluop(aluop_top),.fun7(instruction_top[30]),.fun3(instruction_top[14:12]),.control_out(control_top));

 //alu
alu_unit alu_unit(.A(rd1_top),.B(mux1_top),.Control_in(control_top),.ALU_result(address_top),.zero(zero_top));

//mux
mux1 alu_mux(.sel1(alusrc_top) ,.A1(rd2_top),.B1(immext_top),.mux1_out(mux1_top));  
       
//adder
adder adder(.in_1(PC_top),.in_2(immext_top),.sum_out(sumout_top));

//and gate
and_logic and_logic(.branch(branch_top),.zero(zero_top),.and_out(sel2_top));

//mux2
mux2 adder_mux(.sel2(sel2_top) ,.A2(nextoPC_top),.B2(sumout_top),.mux2_out(PCin_top));  
 
//data memory
data_memory data_memory(.clk(clk),.reset(reset),.memwrite(memwrite_top),.mem_read(memread_top),.read_address(address_top),.write_data(rd2_top),.memdata_out(memdata_top));
        
//mux3 
mux3 memory_mux(.sel3(memtoreg_top) ,.A3(address_top),.B3(memdata_top),.mux3_out(writeback_top)); 

endmodule

