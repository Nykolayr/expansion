/// Общие правила отправки флота (движок и AI).
int defaultFleetSendCount(int shipsOnBase) {
  if (shipsOnBase <= 1) return shipsOnBase;
  return (shipsOnBase / 2).ceil();
}
