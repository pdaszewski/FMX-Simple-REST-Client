unit RESTDataModule_frm;

interface

uses
  System.SysUtils
  ,System.Classes
  ,IPPeerClient
  ,REST.Client
  ,Data.Bind.Components
  ,Data.Bind.ObjectScope
  ,REST.Types
  ,System.JSON
  ,HTTPApp;

type
  TCategoryShow = class(TThread)
  private
   group_id : String;
  protected
    procedure Execute; override;
    procedure DoOnTerminate(Sender: TObject);
  public
   constructor Create(group_id_in: String);
  end;

type
  TRESTDataModule = class(TDataModule)
    RESTClient: TRESTClient;
    Request: TRESTRequest;
    Response: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RESTDataModule: TRESTDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  HeaderFooterTemplate
  ,Categories_frm;

{$R *.dfm}

//####################################################################################
//          The part that supports multithreading
//####################################################################################
constructor TCategoryShow.Create(group_id_in: String);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  OnTerminate     := DoOnTerminate;
  group_id        := group_id_in;
  Resume;
end;

procedure TCategoryShow.Execute;
var
  RESTParam: string;
begin
 RESTParam:='http://localhost:8443/show_categories?group_id='+group_id;
 RESTDataModule.Request.Resource:= RESTParam;
 RESTDataModule.Request.Method  := rmGET;
 try
  try
   RESTDataModule.Request.Execute;
  finally
  end;
 except
 end;
end;

procedure TCategoryShow.DoOnTerminate(Sender: TObject);
begin
  Categories.Result_of_Category_List_Request(RESTDataModule.Response.StatusCode, RESTDataModule.Response.Content);
  inherited;
end;
//####################################################################################


end.
