class Languages
{
  final int id;
  final String name;
  final String langCode;

  Languages(this.id, this.name, this.langCode);
  static List<Languages> languagesLit()
  {
    return <Languages>[
      Languages (1,'English','en',),
      Languages (1,'العربية','ar',),
    ];
  }
}