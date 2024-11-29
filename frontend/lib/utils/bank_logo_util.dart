class BankLogoUtil {
  static final Map<String, String> _logos = {
    'ธนาคารกสิกรไทย': 'assets/LogoBank/Kplus.png',
    'ธนาคารกรุงไทย': 'assets/LogoBank/Krungthai.png',
    'ธนาคารไทยพาณิชย์': 'assets/LogoBank/SCB.png',
    'ธนาคารกรุงเทพ': 'assets/LogoBank/Krungthep.png',
    'ธนาคารกรุงศรี': 'assets/LogoBank/krungsri.png',
    'ธนาคารออมสิน': 'assets/LogoBank/GSB.png',
    'ธนาคารธนชาติ': 'assets/LogoBank/ttb.png',
    'ธนาคารเกียรตินาคิน': 'assets/LogoBank/knk.png',
    'ธนาคารซิตี้แบงก์': 'assets/LogoBank/city.png',
  };

  static String getBankLogo(String bankName) {
    return _logos[bankName.trim()] ?? 'assets/LogoBank/default.png';
  }
}
