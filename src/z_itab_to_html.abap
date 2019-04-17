report z_itab_to_html.

types:
  "RESTRICTION:
  "  the type of each field must
  "  exist as a data item in DDIC
  begin of t_itab_line,
    line type linennr,
    prog type progname,
    baz  type text255,
  end of t_itab_line,
  t_itab type standard table of t_itab_line with empty key.

data(it_itab) = value t_itab(
  ( line = 1 prog = sy-cprog baz = 'Lorem ipsum dolor sit amet,' )
  ( line = 2 prog = sy-cprog baz = 'consectetur adipiscing elit,' )
  ( line = 3 prog = sy-cprog baz = 'sed do eiusmod tempor incididunt' )
  ( line = 4 prog = sy-cprog baz = 'ut labore et dolore magna aliqua.' )
).

data(io_converter) = new zcl_itab_to_html(
  "Setting up CSS for the entire table
  table_style = 'width: 80%; border: #999 1px solid; border-collapse: collapse;'

  "Setting up CSS for header and data lines
  th_style = 'font-weight: bold; border: #999 1px solid; background: #eee;'
  td_style = 'border: #999 1px solid;'
).

"Converting internal table to html
data(i_table) = io_converter->convert( it_itab ).
cl_demo_output=>display_html( i_table ).
