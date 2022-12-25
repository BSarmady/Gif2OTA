object frmMain: TfrmMain
  Left = 175
  Top = 81
  AutoSize = True
  BorderWidth = 10
  Caption = 'OTA Reader V1.0'
  ClientHeight = 362
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Image1: TImage
    Left = 256
    Top = 248
    Width = 288
    Height = 112
  end
  object RzShellTree1: TRzShellTree
    Left = 0
    Top = 0
    Width = 249
    Height = 361
    Indent = 19
    SelectionPen.Color = clBtnShadow
    ShellList = RzShellList1
    TabOrder = 0
  end
  object RzShellList1: TRzShellList
    Left = 256
    Top = 0
    Width = 289
    Height = 241
    Ctl3D = True
    FileFilter = '*.ota;*.gif'
    IconOptions.AutoArrange = True
    Options = [sloAutoFill, sloNonFilesystemAncestors, sloDefaultKeyHandling, sloDynamicRefresh, sloOleDrag, sloOleDrop, sloFolderContextMenu, sloShowHidden, sloFilesCanBeFolders]
    ParentCtl3D = False
    TabOrder = 1
    ViewStyle = vsList
    OnSelectItem = RzShellList1SelectItem
  end
end
