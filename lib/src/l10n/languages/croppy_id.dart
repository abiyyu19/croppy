import 'package:croppy/src/l10n/croppy_localizations.dart';

class CroppyLocalizationsId extends CroppyLocalizations {
  CroppyLocalizationsId() : super('id');

  @override
  String get title => 'Edit Gambar';

  @override
  String get cancelLabel => 'Batal';

  @override
  String get cupertinoFreeformAspectRatioLabel => 'BEBAS';

  @override
  String get cupertinoOriginalAspectRatioLabel => 'ORISINIL';

  @override
  String get cupertinoResetLabel => 'ULANGI';

  @override
  String get cupertinoSquareAspectRatioLabel => 'SQUARE';

  @override
  String get doneLabel => 'Selesai';

  @override
  String get materialFreeformAspectRatioLabel => 'Bebas';

  @override
  String materialGetFlipLabel(LocalizationDirection direction) =>
      'Flip to ${direction == LocalizationDirection.vertical ? 'vertical' : 'horizontal'}';

  @override
  String get materialOriginalAspectRatioLabel => 'Orisinil';

  @override
  String get materialResetLabel => 'Ulangi';

  @override
  String get materialSquareAspectRatioLabel => 'Square';

  @override
  String get saveLabel => 'Simpan';
}
