import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BrasilFieldsApp());

class BrasilFieldsApp extends StatelessWidget {
  const BrasilFieldsApp({super.key});

  ThemeData _theme(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      seedColor: const Color(0xFF006C4C),
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      brightness: brightness,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brasil Fields — Playground',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          title: const _Brand(),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                  icon: Icon(Icons.keyboard_alt_outlined),
                  text: 'Formatadores'),
              Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Datas'),
              Tab(icon: Icon(Icons.dataset_outlined), text: 'Padrões'),
            ],
          ),
        ),
        body: const SafeArea(
          top: false,
          child: TabBarView(
            children: [FormattersPage(), DatesPage(), StandardsPage()],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'BR',
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .4,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Flexible(
          child: Text(
            'Brasil Fields',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ResponsivePage extends StatelessWidget {
  const _ResponsivePage({required this.builder});

  final Widget Function(BuildContext context, double horizontalPadding) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth < 600 ? 16.0 : 32.0;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: builder(context, horizontal),
          ),
        );
      },
    );
  }
}

class _PageIntro extends StatelessWidget {
  const _PageIntro({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: colors.onPrimary, size: 28),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FormattersPage extends StatefulWidget {
  const FormattersPage({super.key});

  @override
  State<FormattersPage> createState() => _FormattersPageState();
}

class _FormattersPageState extends State<FormattersPage> {
  final _searchController = TextEditingController();
  late final List<_FormatterDemo> _demos = _createFormatterDemos();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visible = _demos.where((demo) {
      return query.isEmpty ||
          demo.label.toLowerCase().contains(query) ||
          demo.section.toLowerCase().contains(query);
    }).toList();
    final sections = <String>{for (final demo in visible) demo.section};

    return _ResponsivePage(
      builder: (context, horizontal) => ListView(
        key: const PageStorageKey('formatters-page'),
        padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 48),
        children: [
          const _PageIntro(
            eyebrow: 'Playground interativo',
            title: 'Digite. Formate. Confira na hora.',
            description:
                'Experimente as máscaras do pacote em campos reais. Nada é enviado ou armazenado: toda a formatação acontece no seu dispositivo.',
            icon: Icons.auto_fix_high_outlined,
          ),
          const SizedBox(height: 24),
          TextField(
            key: const Key('formatter-search'),
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              labelText: 'Buscar formatador',
              hintText: 'Ex.: CPF, telefone, moeda…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpar busca',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 32),
          if (visible.isEmpty)
            const _EmptySearch()
          else
            for (final section in sections) ...[
              _SectionHeading(
                title: section,
                count: visible.where((demo) => demo.section == section).length,
              ),
              const SizedBox(height: 12),
              _FormatterGrid(
                demos:
                    visible.where((demo) => demo.section == section).toList(),
              ),
              const SizedBox(height: 32),
            ],
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(Icons.search_off,
              size: 44, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Nenhum formatador encontrado',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Tente buscar por outro nome ou categoria.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          '$count ${count == 1 ? 'formato' : 'formatos'}',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FormatterGrid extends StatelessWidget {
  const _FormatterGrid({required this.demos});

  final List<_FormatterDemo> demos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final demo in demos)
              SizedBox(width: width, child: _FormatterCard(demo: demo)),
          ],
        );
      },
    );
  }
}

class _FormatterCard extends StatelessWidget {
  const _FormatterCard({required this.demo});

  final _FormatterDemo demo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final filter = demo.alphanumeric
        ? FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'))
        : FilteringTextInputFormatter.digitsOnly;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          key: ValueKey('formatter-${demo.id}'),
          keyboardType:
              demo.alphanumeric ? TextInputType.text : TextInputType.number,
          textCapitalization: demo.alphanumeric
              ? TextCapitalization.characters
              : TextCapitalization.none,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: [filter, demo.formatter],
          decoration: InputDecoration(
            labelText: demo.label,
            hintText: demo.hint,
            helperText: demo.formatterName,
          ),
        ),
      ),
    );
  }
}

class DatesPage extends StatefulWidget {
  const DatesPage({super.key});

  @override
  State<DatesPage> createState() => _DatesPageState();
}

class _DatesPageState extends State<DatesPage> {
  final _controller = TextEditingController(text: '21/09/2026');
  String _value = '21/09/2026';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sample = DateTime(2026, 9, 21, 14, 35, 42);
    final digits = UtilData.removeCaracteres(_value);
    final complete = digits.length == 8;
    final day = complete ? UtilData.obterDia(_value) : null;
    final month = complete ? UtilData.obterMes(_value) : null;
    final year = complete ? digits.substring(4) : null;
    return _ResponsivePage(
      builder: (context, horizontal) => ListView(
        key: const PageStorageKey('dates-page'),
        padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 48),
        children: [
          const _PageIntro(
            eyebrow: 'UtilData',
            title: 'Datas brasileiras sem improviso.',
            description:
                'Veja a máscara DD/MM/AAAA em ação e compare as principais saídas de data e hora oferecidas pelo pacote.',
            icon: Icons.event_available_outlined,
          ),
          const SizedBox(height: 24),
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Experimente uma data',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'O campo usa DataInputFormatter e os valores abaixo são extraídos por UtilData.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  key: const Key('date-demo-field'),
                  controller: _controller,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  onChanged: (value) => setState(() => _value = value),
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    hintText: 'DD/MM/AAAA',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _ValueChip(label: 'Dia', value: day?.toString() ?? '—'),
                    _ValueChip(label: 'Mês', value: month?.toString() ?? '—'),
                    _ValueChip(label: 'Ano', value: year ?? '—'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const _SectionHeading(title: 'Formatos disponíveis', count: 5),
          const SizedBox(height: 12),
          _ResultsGrid(
            items: [
              _ResultItem(
                  method: 'obterDataDDMMAAAA',
                  value: UtilData.obterDataDDMMAAAA(sample)),
              _ResultItem(
                  method: 'obterDataMMAAAA',
                  value: UtilData.obterDataMMAAAA(sample)),
              _ResultItem(
                  method: 'obterDataDDMM',
                  value: UtilData.obterDataDDMM(sample)),
              _ResultItem(
                  method: 'obterHoraHHMM',
                  value: UtilData.obterHoraHHMM(sample)),
              _ResultItem(
                  method: 'obterHoraHHMMSS',
                  value: UtilData.obterHoraHHMMSS(sample)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$label  $value',
        style: TextStyle(
          color: colors.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ResultItem {
  const _ResultItem({required this.method, required this.value});
  final String method;
  final String value;
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.items});

  final List<_ResultItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _SurfaceCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.method,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            SelectableText(
                              item.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class StandardsPage extends StatelessWidget {
  const StandardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final states = List.generate(
      Estados.listaEstados.length,
      (index) =>
          '${Estados.listaEstadosSigla[index]} · ${Estados.listaEstados[index]}',
    );
    return _ResponsivePage(
      builder: (context, horizontal) => ListView(
        key: const PageStorageKey('standards-page'),
        padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 48),
        children: [
          const _PageIntro(
            eyebrow: 'Coleções prontas',
            title: 'Padrões brasileiros em um só lugar.',
            description:
                'Use listas consistentes de estados, regiões, meses e dias da semana diretamente na sua interface.',
            icon: Icons.account_tree_outlined,
          ),
          const SizedBox(height: 24),
          const _StatsRow(
            items: [
              _Stat(value: '27', label: 'estados'),
              _Stat(value: '5', label: 'regiões'),
              _Stat(value: '12', label: 'meses'),
            ],
          ),
          const SizedBox(height: 32),
          _CollectionCard(
            title: 'Estados e siglas',
            description: 'Estados.listaEstados + Estados.listaEstadosSigla',
            values: states,
          ),
          const SizedBox(height: 16),
          _CollectionGrid(
            cards: [
              _CollectionCard(
                title: 'Regiões',
                description: 'Regioes.listaRegioes',
                values: Regioes.listaRegioes,
              ),
              _CollectionCard(
                title: 'Meses',
                description: 'Meses.listaMeses',
                values: Meses.listaMeses,
              ),
              _CollectionCard(
                title: 'Dias da semana',
                description: 'Semana.listaDiasSemanaOrdenada',
                values: Semana.listaDiasSemanaOrdenada,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.items});

  final List<_Stat> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final width =
            (constraints.maxWidth - gap * (items.length - 1)) / items.length;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _SurfaceCard(
                  child: Column(
                    children: [
                      Text(
                        item.value,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      Text(item.label, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in cards) SizedBox(width: width, child: card)
          ],
        );
      },
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.title,
    required this.description,
    required this.values,
  });

  final String title;
  final String description;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final value in values) _DataPill(value: value)],
          ),
        ],
      ),
    );
  }
}

class _DataPill extends StatelessWidget {
  const _DataPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Text(value),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: child,
    );
  }
}

class _FormatterDemo {
  const _FormatterDemo({
    required this.id,
    required this.section,
    required this.label,
    required this.hint,
    required this.formatter,
    this.alphanumeric = false,
  });

  final String id;
  final String section;
  final String label;
  final String hint;
  final TextInputFormatter formatter;
  final bool alphanumeric;

  String get formatterName {
    final value = formatter;
    if (value is AlturaInputFormatter) return 'AlturaInputFormatter';
    if (value is CartaoBancarioInputFormatter) {
      return 'CartaoBancarioInputFormatter';
    }
    if (value is CentavosInputFormatter) return 'CentavosInputFormatter';
    if (value is CepInputFormatter) return 'CepInputFormatter';
    if (value is CertNascimentoInputFormatter) {
      return 'CertNascimentoInputFormatter';
    }
    if (value is CESTInputFormatter) return 'CESTInputFormatter';
    if (value is CnpjAlfanumericoInputFormatter) {
      return 'CnpjAlfanumericoInputFormatter';
    }
    if (value is CnpjInputFormatter) return 'CnpjInputFormatter';
    if (value is CNSInputFormatter) return 'CNSInputFormatter';
    if (value is CpfOuCnpjAlfanumericoFormatter) {
      return 'CpfOuCnpjAlfanumericoFormatter';
    }
    if (value is CpfOuCnpjFormatter) return 'CpfOuCnpjFormatter';
    if (value is CpfInputFormatter) return 'CpfInputFormatter';
    if (value is DataInputFormatter) return 'DataInputFormatter';
    if (value is HoraInputFormatter) return 'HoraInputFormatter';
    if (value is IOFInputFormatter) return 'IOFInputFormatter';
    if (value is KmInputFormatter) return 'KmInputFormatter';
    if (value is NCMInputFormatter) return 'NCMInputFormatter';
    if (value is NUPInputFormatter) return 'NUPInputFormatter';
    if (value is PesoInputFormatter) return 'PesoInputFormatter';
    if (value is PisPasepInputFormatter) return 'PisPasepInputFormatter';
    if (value is PlacaVeiculoInputFormatter) {
      return 'PlacaVeiculoInputFormatter';
    }
    if (value is RealInputFormatter) return 'RealInputFormatter';
    if (value is TelefoneInputFormatter) return 'TelefoneInputFormatter';
    if (value is TelefoneFixoInputFormatter) {
      return 'TelefoneFixoInputFormatter';
    }
    if (value is CelularInputFormatter) return 'CelularInputFormatter';
    if (value is TelefoneOuCelularInputFormatter) {
      return 'TelefoneOuCelularInputFormatter';
    }
    if (value is TemperaturaInputFormatter) {
      return 'TemperaturaInputFormatter';
    }
    if (value is ValidadeCartaoInputFormatter) {
      return 'ValidadeCartaoInputFormatter';
    }
    return value.runtimeType.toString();
  }
}

List<_FormatterDemo> _createFormatterDemos() => [
      _demo(
          'cnpj-alfanumerico',
          'Novidades recentes',
          'CNPJ alfanumérico (2026)',
          '14.890.N2J/709Y-05',
          CnpjAlfanumericoInputFormatter(),
          true),
      _demo('pis-pasep', 'Novidades recentes', 'PIS/PASEP (NIS/NIT)',
          '120.12345.67-2', PisPasepInputFormatter()),
      _demo('cep', 'Documentos e identificadores', 'CEP', '01.310-100',
          CepInputFormatter()),
      _demo('cpf', 'Documentos e identificadores', 'CPF', '334.616.710-02',
          CpfInputFormatter()),
      _demo('cnpj', 'Documentos e identificadores', 'CNPJ',
          '12.175.094/0001-19', CnpjInputFormatter()),
      _demo('cpf-cnpj', 'Documentos e identificadores', 'CPF ou CNPJ',
          'Digite 11 ou 14 dígitos', CpfOuCnpjFormatter()),
      _demo(
          'cpf-cnpj-alfanumerico',
          'Documentos e identificadores',
          'CPF ou novo CNPJ',
          'Aceita o CNPJ alfanumérico',
          CpfOuCnpjAlfanumericoFormatter(),
          true),
      _demo(
          'certidao',
          'Documentos e identificadores',
          'Certidão de nascimento',
          'Matrícula com 32 dígitos',
          CertNascimentoInputFormatter()),
      _demo('nup', 'Documentos e identificadores', 'NUP',
          '0601064-21.2022.6.00.0000', NUPInputFormatter()),
      _demo('cns', 'Documentos e identificadores', 'CNS', '000 1111 2222 3333',
          CNSInputFormatter()),
      _demo('telefone-fixo', 'Contato, tempo e mobilidade', 'Telefone fixo',
          '(11) 3456-7890', TelefoneFixoInputFormatter()),
      _demo('celular', 'Contato, tempo e mobilidade', 'Celular',
          '(11) 98765-4321', CelularInputFormatter()),
      _demo(
        'telefone-ou-celular',
        'Contato, tempo e mobilidade',
        'Telefone ou celular',
        'Aceita 10 ou 11 dígitos',
        TelefoneOuCelularInputFormatter(),
      ),
      _demo('data', 'Contato, tempo e mobilidade', 'Data', '21/09/2026',
          DataInputFormatter()),
      _demo('hora', 'Contato, tempo e mobilidade', 'Hora', '14:35',
          HoraInputFormatter()),
      _demo('placa', 'Contato, tempo e mobilidade', 'Placa de veículo',
          'BRA-2E19', PlacaVeiculoInputFormatter(), true),
      _demo('km', 'Contato, tempo e mobilidade', 'Quilometragem', '123.456',
          KmInputFormatter()),
      _demo('centavos', 'Valores e medidas', 'Centavos', '123,45',
          CentavosInputFormatter()),
      _demo('centavos-moeda', 'Valores e medidas', 'Centavos com moeda',
          r'R$ 123,45', CentavosInputFormatter(moeda: true)),
      _demo('centavos-3', 'Valores e medidas', 'Centavos com 3 decimais',
          '123,456', CentavosInputFormatter(casasDecimais: 3)),
      _demo('centavos-3-moeda', 'Valores e medidas', '3 decimais com moeda',
          r'R$ 123,456', CentavosInputFormatter(casasDecimais: 3, moeda: true)),
      _demo('real', 'Valores e medidas', 'Real', '1.234,56',
          RealInputFormatter()),
      _demo('real-moeda', 'Valores e medidas', 'Real com moeda', r'R$ 1.234,56',
          RealInputFormatter(moeda: true)),
      _demo('peso', 'Valores e medidas', 'Peso', '103,5', PesoInputFormatter()),
      _demo('altura', 'Valores e medidas', 'Altura', '1,82',
          AlturaInputFormatter()),
      _demo('temperatura', 'Valores e medidas', 'Temperatura', '20,5',
          TemperaturaInputFormatter()),
      _demo('iof', 'Valores e medidas', 'IOF', '1,234567', IOFInputFormatter()),
      _demo('cartao', 'Códigos comerciais e bancários', 'Cartão bancário',
          '1111 2222 3333 4444', CartaoBancarioInputFormatter()),
      _demo('validade-cartao', 'Códigos comerciais e bancários',
          'Validade do cartão', '12/30', ValidadeCartaoInputFormatter()),
      _demo('ncm', 'Códigos comerciais e bancários', 'NCM', '1234.56.78',
          NCMInputFormatter()),
      _demo('cest', 'Códigos comerciais e bancários', 'CEST', '12.345.67',
          CESTInputFormatter()),
    ];

_FormatterDemo _demo(
  String id,
  String section,
  String label,
  String hint,
  TextInputFormatter formatter, [
  bool alphanumeric = false,
]) =>
    _FormatterDemo(
      id: id,
      section: section,
      label: label,
      hint: hint,
      formatter: formatter,
      alphanumeric: alphanumeric,
    );
