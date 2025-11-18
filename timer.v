`timescale 1s/1s
`define width 16
module timer(
  input clk,
  input write,//高电平有效，当这个信号亮起时，insec，inmin ,inhour,up 信号才有效，才能被正确写入
  input up , //计数方向控制（1=正计时，0=倒计时）
  input cut_n,//低电平有效，复位/中断信号
  input [`width-1:0]insec,
  input [`width-1:0]inmin ,
  input [`width-1:0]inhour,
  input start, //这个信号亮起，才会开始正计时或者倒计时
  output [`width-1:0]sec,
  output [`width-1:0]min,
  output [`width-1:0]hour,
  output alarm,//这个信号亮起代表正计时或者倒计时结束
  output buzy_n //在这个信号为低电平的时候，所有的写入信号都无法生效，只有使用cut_n信号中止计时之后才能让机器中止运转并接收新的写入信号
);
reg [`width-1:0]sec_set,min_set,hour_set;
reg buzy_n_r_last;
reg buzy_n_r;
reg [`width-1:0] sec_r,min_r,hour_r;
reg up_r;
assign alarm=((up_r&(sec_r==sec_set)&(min_r==min_set)&(hour_r==hour_set)&(sec_r!=0)&(min_r!=0)&(hour_r!=0))|
    (!up_r&(sec_r==0)&(min_r==0)&(hour_r==0)));
assign sec=sec_r;
assign min=min_r;
assign hour=hour_r;
assign buzy_n=buzy_n_r;
always @(posedge clk) begin
  if(cut_n) begin
    up_r<=0;
    sec_set<=0;
    min_set<=0;
    hour_set<=0;
  end else begin
    if (write&&buzy_n_r)begin
      buzy_n_r<=0;
      sec_set<=insec;
      min_set<=inmin;
      hour_set<=inhour;
      up_r<=up;
    end else begin
      sec_set<=sec_set;
      min_set<=min_set;
      hour_set<=hour_set;
      up_r<=up_r;
    end
  end
end
always @ (posedge clk) begin
  if(cut_n||alarm) begin
    buzy_n_r<=1;
    buzy_n_r_last<=buzy_n_r;
  end else if(start) begin
    buzy_n_r<=0;
    buzy_n_r_last<=buzy_n_r;
  end else begin
    buzy_n_r<=buzy_n_r;
    buzy_n_r_last<=buzy_n_r_last;
  end
end
always @ (posedge clk) begin
  if(cut_n||buzy_n_r||alarm) begin
    if(up_r) begin
      sec_r<=0;
      min_r<=0;
      hour_r<=0;
    end else begin
      sec_r<=sec_set;
      min_r<=min_set;
      hour_r<=hour_set;
    end
  end else begin
    if(up_r) begin
      if(sec_r==59)begin
        if(min_r==59)begin
          hour_r<=hour_r+1;
          min_r<=0;
          sec_r<=0;
        end else begin
          hour_r<=hour_r;
          min_r<=min_r+1;
          sec_r<=0;
        end
      end else begin
        hour_r<=hour_r;
        min_r<=min_r;
        sec_r<=sec_r+1;
      end
    end else begin
      if(sec_r==0)begin
        if(min_r==0)begin
          hour_r<=hour_r-1;
          min_r<=59;
          sec_r<=59;
        end else begin
          hour_r<=hour_r;
          min_r<=min_r-1;
          sec_r<=59;
        end
      end else begin
        hour_r<=hour_r;
        min_r<=min_r;
        sec_r<=sec_r-1;
      end 
    end
  end
end
endmodule
