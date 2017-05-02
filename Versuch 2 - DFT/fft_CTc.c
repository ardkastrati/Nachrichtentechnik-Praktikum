#include "mex.h" 
#include "math.h"
#include "string.h"

#ifndef M_PI
#  define M_PI 3.141592653589793238
#endif

/* computational subroutine */
void fft_CT(double *xr, double *xi, double *Xr, double *Xi, size_t M)
{  
    mwSize n; /* loop counter */
    double wr, wi; /* twiddle factor*/
    
    if(M <= 1)
    {
        /* nothing to do... copy input to output */
        memcpy(Xr, xr, M * sizeof(double));
        memcpy(Xi, xi, M * sizeof(double));       
    }
    else
    {
        /* butter flies */
        for(n = 0; n < M/2; n++) 
        {            
            Xr[n] = xr[n] + xr[n + M/2];
            Xi[n] = xi[n] + xi[n + M/2];
            
            wr =  cos(2*M_PI * n/M); 
            wi = -sin(2*M_PI * n/M);
            Xr[n + M/2] = (xr[n] - xr[n + M/2]) * wr
                        - (xi[n] - xi[n + M/2]) * wi;
            Xi[n + M/2] = (xi[n] - xi[n + M/2]) * wr
                        + (xr[n] - xr[n + M/2]) * wi;
        }
        
        /* sub-ffts */
        fft_CT(Xr      , Xi      , xr,       xi      , M/2);
        fft_CT(Xr + M/2, Xi + M/2, xr + M/2, xi + M/2, M/2);
        
        /* recursive bit reversal */
        for(n = 0; n < M/2; n++)
        {
            Xr[2*n    ] = xr[n      ];
            Xi[2*n    ] = xi[n      ];
            Xr[2*n + 1] = xr[n + M/2];
            Xi[2*n + 1] = xi[n + M/2];
        }
    }
}

void mexFunction( int nlhs, mxArray *plhs[],          /* Outputs: X */
                  int nrhs, const mxArray *prhs[])    /* Inputs: x, M */
{    
    double *xr, *xi, *xxr, *xxi, *Xr, *Xi;
    size_t rows, cols;
    size_t n, nx, M;
    
    if(nrhs != 2)
      mexErrMsgIdAndTxt( "MATLAB:convec:invalidNumInputs",  "Two inputs required.");
    if(nlhs > 1)
      mexErrMsgIdAndTxt( "MATLAB:convec:maxlhs", "Too many output arguments.");
    
    /* get and check fft length param */
    M = (size_t)mxGetScalar(prhs[1]);
    if(pow(2, floor(log(M) / log(2))) != M)
      mexErrMsgIdAndTxt( "MATLAB:convec:invalidInput", "Only radix 2.");
    
    /* get pointers to the real and imaginary parts of the input data */
    xr = mxGetPr(prhs[0]);
    xi = mxIsComplex(prhs[0])? mxGetPi(prhs[0]) : 0;
    /* get input dimensions */
    rows = mxGetM(prhs[0]); 
    cols = mxGetN(prhs[0]);
    nx = rows * cols;
  
    /* create a new array and set the output pointers */
	if(rows > 1) rows = M; else cols = M;
    plhs[0] = mxCreateDoubleMatrix((mwSize)rows, (mwSize)cols, mxCOMPLEX);
    Xr = mxGetPr(plhs[0]);
    Xi = mxGetPi(plhs[0]);
        
    /* buffer for zero padded or truncated input data */
    xxr = mxMalloc(M * sizeof(double));
    xxi = mxMalloc(M * sizeof(double));
    for(n=0; n < M; n++) 
    {
        xxr[n] = (n < nx)? xr[n]: 0.0;
        xxi[n] = (mxIsComplex(prhs[0]) && n < nx)? xi[n]: 0.0;
    }   
    
    /* call the fft subroutine */
    fft_CT(xxr, xxi, Xr, Xi, M);

    /* free buffers */
    mxFree(xxr);
    mxFree(xxi);
}