SpreadsheetChecksum = ->(spreadsheet) {
  rows = spreadsheet.split("\n")

  rows.inject(0) {|sum, row| sum += RowChecksum.call(row) }
}
