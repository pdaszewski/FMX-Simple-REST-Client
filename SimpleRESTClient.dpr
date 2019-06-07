program SimpleRESTClient;









uses
  System.StartUpCopy,
  FMX.Forms,
  HeaderFooterTemplate in 'HeaderFooterTemplate.pas' {LoginForm},
  RESTDataModule_frm in 'RESTDataModule_frm.pas' {RESTDataModule: TDataModule},
  Categories_frm in 'OknaProjektu\Categories_frm.pas' {Categories};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TRESTDataModule, RESTDataModule);
  Application.CreateForm(TCategories, Categories);
  Application.Run;
end.
