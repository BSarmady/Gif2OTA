unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, RzListVw, RzShellCtrls, RzTreeVw, StdCtrls,
  FileCtrl, RzFilSys, GIFImg;

type
  TfrmMain = class(TForm)
    Image1: TImage;
    RzShellTree1: TRzShellTree;
    RzShellList1: TRzShellList;
    procedure RzShellList1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    procedure SetBlackWhite;
    procedure ShowOTA(FilePath:string);
    procedure ShowGif(FilePath:string);
    procedure CreateOTA(FilePath:string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.RzShellList1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin

  if (RzShellList1.ItemIndex>-1) and (not RzShellList1.SelectedItem.IsFolder) then begin
    if (ExtractFileExt(RzShellList1.SelectedItem.FileName)='.gif') then
      ShowGif(RzShellList1.SelectedItem.PathName)
    else
      ShowOTA(RzShellList1.SelectedItem.PathName);
  end;
end;

procedure TfrmMain.ShowOTA(FilePath:string);
var
  f:file of byte;
  buffer:array[0..255] of byte;
  code:integer;
  BufferPos:byte;
  PosX,PosY:byte;
  X:integer;
  thisByte:byte;
begin
  if FileExists(FilePath) then begin
    AssignFile(f,FilePath);Reset(f);
    BlockRead(f,buffer,Sizeof(buffer),code);
    CloseFile(f);
    image1.Canvas.Brush.Color:=clWhite;
    image1.Canvas.FillRect(Rect(0,0,image1.Width,Image1.Height));
    Image1.Canvas.Pen.Color:=clBlack;
    Image1.Canvas.Brush.Color:=clBlack;
    BufferPos := 4;

    for PosY := 0 to buffer[2]-1 do
      for PosX := 0 to (buffer[1] div 8)-1 do begin
        thisByte:=buffer[BufferPos];
        for X:=7 downto 0 do begin
          if (thisByte and 1)=1 then
            Image1.Canvas.Rectangle(((PosX * 8) + X)*4,PosY*4,((PosX * 8) + X)*4 + 4,PosY*4 +4);
          thisByte := thisByte shr 1;
        end;
        inc(BufferPos);
      end;
  end;
end;

procedure TfrmMain.ShowGif(FilePath:string);
var
  f:file of byte;
  buffer:array[0..255] of byte;
  code:integer;
  BufferPos:byte;
  PosX,PosY:byte;
  X:integer;
  thisByte:byte;
  GifImage:TGIFImage;
begin
  if FileExists(FilePath) then begin
    GifImage:=TGIFImage.Create;
    GifImage.LoadFromFile(FilePath);
    GifImage.Transparent:=false;
    GifImage.BackgroundColor:=clWhite;
    image1.Canvas.Brush.Color:=clWhite;
    image1.Canvas.FillRect(Rect(0,0,image1.Width,Image1.Height));
    for PosY:=0 to (Image1.Height div 4)-1 do
      for PosX:=0 to (Image1.Width div 4)-1 do begin
        Image1.Canvas.Pen.Color:= GifImage.Bitmap.Canvas.Pixels[PosX,PosY];
        Image1.Canvas.Brush.Color:= GifImage.Bitmap.Canvas.Pixels[PosX,PosY];
        Image1.Canvas.Rectangle(PosX*4,PosY*4,PosX*4 + 4,PosY*4 +4);
      end;
  end;
  SetBlackWhite;
  CreateOTA(FilePath);
end;

procedure TfrmMain.CreateOTA(FilePath:string);
var
  f:file of byte;
  buffer:array[0..255] of byte;
  code:integer;
  BufferPos:integer;
  PosX,PosY:byte;
  X:byte;
  thisByte:byte;
begin
  FilePath:= StringReplace(FilePath,ExtractFileExt(FilePath),'.ota',[rfReplaceAll]);
  Buffer[0]:=0;
  Buffer[1]:= 72;
  Buffer[2]:= 28;
  Buffer[3]:=1;
  BufferPos := 4;
  for PosY := 0 to buffer[2]-1 do
    for PosX := 0 to (buffer[1] div 8) -1 do begin
      thisByte:=0;
      for X:=0 to 7 do begin
        if Image1.Canvas.Pixels[(PosX * 8 +X) * 4 ,PosY * 4]= clblack then
          thisByte :=  thisByte shl 1 or 1
        else
          thisByte :=  thisByte shl 1;
      end;
      buffer[BufferPos]:=thisByte;
      inc(BufferPos);
    end;
  AssignFile(f,FilePath);Rewrite(f);
  BlockWrite(f,buffer,BufferPos);
  CloseFile(f);
end;

procedure TfrmMain.SetBlackWhite;
var
  i,j:integer;
  red, green, blue:integer;
  color:TColor;
begin
  for i:=0 to (Image1.Width div 4) - 1  do
    for j:=0 to (Image1.Height div 4) - 1 do begin
      blue:= Image1.Canvas.Pixels[i*4,j*4] and 255;
      green:= (Image1.Canvas.Pixels[i*4,j*4] shr 8) and 255;
      red:= (Image1.Canvas.Pixels[i*4,j*4] shr 16) and 255;
      color:= (blue + green + red)  div 3;
      if color>32 then
        color:=255
      else
        color:=0;
      Image1.Canvas.Pen.Color:= RGB(color,color,color);
      Image1.Canvas.Brush.Color:= RGB(color,color,color);
      Image1.Canvas.Rectangle(I*4,J*4,I*4 + 4,J*4 +4);
    end;
end;

end.
