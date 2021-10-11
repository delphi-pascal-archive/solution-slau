unit lin_system1_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;
  
type
  Tfrm_about = class(TForm)
    BitBtn1: TBitBtn;
    Image2: TImage;
    Timer1: TTimer;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    Timer2: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  end;
  
const  TT_SPACE     = 5 ;
  Banniere     = 'Sami Oubbati';
var
  frm_about: Tfrm_about;
  
implementation

{$R *.dfm}

procedure Tfrm_about.BitBtn1Click(Sender: TObject);
begin
  AnimateWindow(Handle, 360, AW_BLEND or AW_HIDE);
  Close;

end;

procedure Tfrm_about.FormCreate(Sender: TObject);
begin
  Randomize;
  with image1.Picture.Bitmap.Create do
  begin
    PixelFormat:=pf4bit;
    Width:=image1.Width;
    Height:=image1.Height;
    //LE DESSIN
    Canvas.Pen.Style:=psClear;
    Canvas.Brush.Color:=clWhite;
    //EFFACEMENT DE L'ARRIERE-PLAN
    Canvas.Brush.Style:=bsSolid;
    Canvas.Rectangle(-1,-1,image1.Width+1,image1.Height+1);
    //LA FONTE
    Canvas.Font.Name:='Times New Roman';
    Canvas.Font.Style:=[fsBold];
    Canvas.Font.Size:=28;
  end;
end;

procedure Tfrm_about.Timer1Timer(Sender: TObject);
var i, x    : Integer;
  PX, PY  : Integer;
begin
  //EFFACEMENT DE L'ARRIERE-PLAN
  image1.Picture.Bitmap.Canvas.Brush.Style:=bsSolid;
  image1.Picture.Bitmap.Canvas.Rectangle(-1,-1,image1.Width+1,image1.Height+1);
  //DESSIN DES CARACTERES
  x:=0;
  for i:=1 to Length(Banniere) do
  begin
    PX:=random(10)+1+x;
    PY:=random(10)+1;
    image1.Picture.Bitmap.Canvas.Brush.Style:=bsClear;
    image1.Picture.Bitmap.Canvas.TextOut(PX,PY,Banniere[i]);
    x:=x+image1.Picture.Bitmap.Canvas.TextWidth(Banniere[i])+TT_SPACE;
  end;
end;

procedure Tfrm_about.Timer2Timer(Sender: TObject);
begin

if(label6.Font.color=clWindowText)then
  begin
    label6.Font.Color:=clred;
    label7.Font.Color:=clred;
  end
else
  begin
    if(label6.Font.color=clred)then
      begin
        label6.Font.Color:=cllime;
        label7.Font.Color:=cllime;
      end
    else
      begin
        if(label6.Font.color=cllime)then
          begin
            label6.Font.color:=clWindowText;
            label7.Font.color:=clWindowText;
          end;
      end;
  end;
end;

end.
