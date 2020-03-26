function y = cellabs( x )
[m n] = size( x );
y = cell( m, n );
for jj = 1:m*n
  if iscell( x{jj} )
    y{jj} = cellabs( x{jj} );
  else
    y{jj} = abs( x{jj} );
  end
end
end