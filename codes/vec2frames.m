function [ frames, indexes ] = vec2frames( vec, Nw, Ns, direction, window, padding )


    % usage information
    usage = 'usage: [ frames, indexes ] = vec2frames( vector, frame_length, frame_shift, direction, window, padding );';

    % default settings 
    switch( nargin )
    case { 0, 1, 2 }, error( usage );
    case 3, padding=false; window=false; direction='cols';
    case 4, padding=false; window=false; 
    case 5, padding=false; 
    end

    % input validation
    if( isempty(vec) || isempty(Nw) || isempty(Ns) ), error( usage ); end;
    if( min(size(vec))~=1 ), error( usage ); end;
    if( Nw==0 || Ns==0 ), error( usage ); end;

    vec = vec(:);                       % ensure column vector

    L = length( vec );                  % length of the input vector
    M = floor((L-Nw)/Ns+1);             % number of frames 


    % perform signal padding to enable exact division of signal samples into frames 
    % (note that if padding is disabled, some samples may be discarded)
    if( ~isempty(padding) )
 
        % figure out if the input vector can be divided into frames exactly
        E = (L-((M-1)*Ns+Nw));

        % see if padding is actually needed
        if( E>0 ) 

            % how much padding will be needed to complete the last frame?
            P = Nw-E;

            % pad with zeros
            if( islogical(padding) && padding ) 
                vec = [ vec; zeros(P,1) ];

            % pad with a specific numeric constant
            elseif( isnumeric(padding) && length(padding)==1 ) 
                vec = [ vec; padding*ones(P,1) ];

            % pad with a low variance white Gaussian noise
            elseif( isstr(padding) && strcmp(padding,'noise') ) 
                vec = [ vec; 1E-6*randn(P,1) ];

            % pad with a specific variance white Gaussian noise
            elseif( iscell(padding) && strcmp(padding{1},'noise') ) 
                if( length(padding)>1 ), scale = padding{2}; 
                else, scale = 1E-6; end;
                vec = [ vec; scale*randn(P,1) ];

            % if not padding required, decrement frame count
            % (not a very elegant solution)
            else
                M = M-1;

            end

            % increment the frame count
            M = M+1;
        end
    end


    % compute index matrix 
    switch( direction )

    case 'rows'                                                 % for frames as rows
        indf = Ns*[ 0:(M-1) ].';                                % indexes for frames      
        inds = [ 1:Nw ];                                        % indexes for samples
        indexes = indf(:,ones(1,Nw)) + inds(ones(M,1),:);       % combined framing indexes
    
    case 'cols'                                                 % for frames as columns
        indf = Ns*[ 0:(M-1) ];                                  % indexes for frames      
        inds = [ 1:Nw ].';                                      % indexes for samples
        indexes = indf(ones(Nw,1),:) + inds(:,ones(1,M));       % combined framing indexes
    
    otherwise
        error( sprintf('Direction: %s not supported!\n', direction) ); 

    end


    % divide the input signal into frames using indexing
    frames = vec( indexes );


    % return if custom analysis windowing was not requested
    if( isempty(window) || ( islogical(window) && ~window ) ), return; end;
    
    % if analysis window function handle was specified, generate window samples
    if( isa(window,'function_handle') )
        window = window( Nw );
    end
    
    % make sure analysis window is numeric and of correct length, otherwise return
    if( isnumeric(window) && length(window)==Nw )

        % apply analysis windowing beyond the implicit rectangular window function
        switch( direction )
        case 'rows', frames = frames * diag( window );
        case 'cols', frames = diag( window ) * frames;
        end

    end


% EOF 
