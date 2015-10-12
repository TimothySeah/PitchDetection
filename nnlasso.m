function x = nnlasso(y, A, lambda)
% given observation vector y, matrix A, regularization parameter lambda
% (lambda is nonnegative; as lambda increases, the number of nonzero
% components of beta decreases), and a list of notes corresponding to the
% columns of A,
% return x (the predicted amplitudes of the notes)

cvx_begin
    variable x(size(A, 2))
    minimize( norm( A * x - y, 2 ) + lambda * norm(x, 1) )
    subject to
        eye(size(A,2)) * x >= 0
cvx_end

end