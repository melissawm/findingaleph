function [meannormdif, meanerrors, outC, inC] = readpfile(outfilename, ...
							  infilename, batchsize)

    % This function reads the data from the input and results file for the
    % randomly generated "bacterial" data and calls tests.m to perform
    % some user defined statistical analysis on this data. Since the 
    % amount of data (100 million matrices) exceeds the amount that MATLAB can
    % treat at a time, we will do the analysis by chunks of dimension batchsize.
    % Usage:
    % >> [meannormdif, meanerrors, outC, inC] = readpfile(outfilename, 
    %							  infilename, 
    %                                                     batchsize)


    % Input arguments:
    % outfilename : string of the type pefileXX.txt, where XX is some number
    %               between 01 and 10 (these are the P+E matrices).
    % infilename  : string of the type matrizesXX.txt, where XX is some number
    %               between 01 and 10 (these are the input matrices).
    % batchsize : size of the chunk of data that will be read at each cycle. 
    %             Typical value: 100000

    % Output arguments:
    % meannormdif : the mean of the Frobenius norm of the Epsilon matrices.
    % meanerrors : the mean of all absolute values of the persymmetric
    %              differences for diag(X)*(P+Epsilon) - the constraint
    %              violations.
    % outC : cell with the contents of pefileXX.txt, where XX is some number
    %        between 01 and 10.
    % inC  : cell with the contents of matrizesXX.txt, where XX is some number
    %        between 01 and 10.  
  
    outfmt = [repmat('%n', 1, 20)];
    outfileID = fopen(outfilename,'r');
        
    infmt = '%n %n %n %n \n %n %n %n %n \n %n %n %n %n \n %n %n %n %n \n';
    infileID = fopen(infilename, 'r');
    
    % Each pefile contains 10.000.000 matrices.
    % We will read batchsize matrices at a time, process them, and 
    % then go to the next batch. textscan automatically reads the file from 
    % the last position read.

    % Each line k of  contains x in the first 4 entries, and Epsilon in the
    % next
    % 16 entries, such that
    %     for i = 1:4
    %         for j = 1:4
    %             Epsilon(i,j) = A(k,4+j+(i-1)*4);
    %         end
    %     end
    % Matrices are stored in 10 files calles pefile01.txt - pefile10.txt

    k = 0;
    frewind(outfileID);
    frewind(infileID);

    meanerrors = [];
    meannormdif = [];
    while ~feof(outfileID)
	disp(['Processing batch ', num2str(k+1), ' of ', num2str(ceil(100000000/batchsize)), '...'])
	% textscan returns cells outC and inC for later use.
        outC = textscan(outfileID,outfmt,batchsize, 'CollectOutput', '1', ...
		        'ReturnOnError', '0', 'Delimiter', '\n');
        inC = textscan(infileID,infmt,batchsize, 'CollectOutput', '1');
        %
        if min(size(outC{1})) == 0
            disp('Error in pefile - outfile')
        elseif min(size(inC{1})) == 0
            disp('Error in matrix - infile')
        else
            % The function tests can be altered to compute statistics and 
            % other information from the files. But then, the output arguments
            % for readpfile must be changed accordingly.
            [meannormdif(k+1), meanerrors(k+1)] = tests(outC, inC, batchsize);
        end
        k = k+1;
    end
    fclose(outfileID);
    fclose(infileID);
end
