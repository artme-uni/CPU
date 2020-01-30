`timescale 1ns / 1ps

module rom(addr_read, data_read);

    input [7 : 0] addr_read;
    output [15 : 0] data_read;

    logic [15 : 0] mem [0 : 255];
    initial $readmemh("rom.txt", mem, 0, 255);
    
    assign data_read = mem[addr_read];
endmodule



module ram(addr_write, addr_read, data_write, data_read, clock_write);

    input [7 : 0] addr_write;
    input [7 : 0] addr_read;
    input [7 : 0] data_write;
    output [7 : 0] data_read;
    input clock_write;
    
    logic [7 : 0] mem [0 : 255];
    assign data_read = mem[addr_read];
    
    always @ (posedge clock_write) 
        mem[addr_write] <= data_write;
endmodule



module cpu(clock, reset, port_out, port_in, cmd_out, reg_pc_out, addr_out);

    input clock;
    input reset;
    output logic [7:0] port_out;
    input [7:0] port_in;
    output [7:0] cmd_out;
    output [7:0] reg_pc_out;
    output [7:0] addr_out;
    
    parameter LOAD  = 8'h00;
    parameter SCAN  = 8'h08;
    parameter SAVE  = 8'h07;
    parameter OUT   = 8'h05;
    
    parameter SHIFT = 8'h0b;
    parameter SKIP  = 8'h0c;
 
    parameter ADD = 8'h01;
    parameter SUB = 8'h02;
    parameter DIV = 8'h03;
    parameter MUL = 8'h04;
    parameter INC = 8'h09;
    parameter DEC = 8'h0a; 
    
    
    logic [7:0] address; 
    logic [7:0] addr_read, addr_write;
    logic [7:0] cmd;
    logic [7:0] cmd_addr;
    logic [7:0] data_read, data_write;
    
    logic [7:0] temp;
    logic [7:0] register;
    
    rom ROM(.addr_read(cmd_addr), .data_read({cmd, address}));
    ram RAM(.addr_read(addr_read), .addr_write(addr_write), .data_read(data_read), .data_write(data_write), .clock_write(clock));
    
    assign cmd_out = cmd;
    
    assign reg_pc_out = cmd_addr;
    assign addr_out = address;


    assign addr_read = cmd == ADD || cmd == SUB || cmd == MUL || cmd == DIV || cmd == LOAD || cmd == OUT ? address : addr_read;
    
    assign data_write = cmd == SAVE ? temp : data_write;              
    assign addr_write = cmd == SAVE ? address : addr_write;
    
    assign register = cmd == LOAD ? data_read : 
                    (cmd == ADD ? temp + data_read :
                    (cmd == SUB ? temp - data_read :
                    (cmd == MUL ? temp * data_read :
                    (cmd == DIV ? temp / data_read :
                    (cmd == INC ? temp + 1:
                    (cmd == DEC ? temp - 1:
                    (cmd == SCAN ? address :
                     temp)))))));
                     
    
    always@ (posedge clock) begin
        if (reset) begin
            temp <= 0;
            cmd_addr <= 0;
            port_out <= 0;

        end else begin
            temp <= register;
            cmd_addr <= cmd == SHIFT ? (cmd_addr - temp) :
                       (cmd == SKIP ? ((temp == 0) ? cmd_addr + 3 : cmd_addr + 1) :
                        cmd_addr + 1);
            
            port_out <= cmd == OUT ? temp : port_out;
        end
    end

endmodule