load(input('Ange datafil: ','s'))
tic;
[m,n] = size(A);

% Skapa nix, dvs indexvektorn för ickebasvariabler
nix = setdiff([1:n],bix);

% Skapa initial partition
B = A(:,bix);
N = A(:,nix);
cB = c(bix,:);
cN = c(nix,:);

opt=0;
iter = 0;
while opt==0,
    iter = iter + 1;
        
        % Röknar ut B^-1 aka B invers
        
    inverseB = inv(B);
    
        % Beräknar sedan högerledet
        
    xB = inverseB * b;
    
        %Beräknar våra skuggpriser med c^Tb aka cB transponat och B⁻1 aka B invers samt transponerar hela
    
    y = (cB.' * inverseB).';    
    
        % Beräknar målfunktionsvärdet z = b^T*y
        
    z = b.' * y;
      

    % Beräkna reducerad kostnad och högerled
    % -------
    
        %Beräknar reducerad kostnad genom cN - N^T*y
    
    redCost = cN - (N.' * y);
    
    % Beräkna mest negativ reducerad kostnad, rc_min,
    %  och index för inkommande variabel, inkix
    % -------
    
        %Finns både minvärde och index för minsta reducerade kostnaden

    [rc_min, inkix] = min(redCost);

    if rc_min >= -1.0E-10
        opt=1;
        disp('Optimum');
    else
        % Beräkna inkommande kolumn, a
        % --------
        
            %Beräknar inkommande kolumn i A som ges av indexet inkix vilket
            %är inkommande variabeln. Multiplicerar med B^-1 för att uppdatera med hänsyn till aktuell bas
        a = inverseB*N(:,inkix);
        
            
        
        if max(a) <= 0 
            disp('Obegränsad lösning');
            return;
        else
            % Bestäm utgående variabel, utgix
            % -------
                %Loopar igenom inkommande kolumnen
                
                %Ansätter lägsta variabeln till infinity så alla som
                %faktiskt finns ska vara mindre
            lowestValue = inf;
            for i = 1:size(a)
                    %Undviker division med noll
                if a(i) ~= 0
                        %Kontrollerar att kvoten är större än noll
                    if xB(i)/a(i) > 0
                            %Ansätter kvoten till tmp
                      tmp = xB(i)/a(i);
                            %kontrollerar ifall vårt lägsta värde är större
                            %än senaste kvoten
                            
                      if lowestValue > tmp
                                %Ifall den är det ansätter vi nya kvoten
                                %som minsta värde och uppdaterar utgående
                                %variabels index
                          lowestValue = tmp;
                          utgix = i;
                      end 
                    end
                end
            end
        
            


            disp(sprintf('Iter: %d, z: %f, rc_min: %f, ink: %d, utg: %d ',iter,z,rc_min,nix(inkix),bix(utgix)));

            % Konstruera ny partitionering mha ink och utg
            % --------
             % --------
            temp = bix(utgix);
            
            bix(utgix) = nix(inkix);
            nix(inkix) = temp; 
            
            % Skapar ny partition som i starten
            B = A(:,bix);
            N = A(:,nix);
            cB = c(bix,:);
            cN = c(nix,:);
        end
    end
end

toc
disp(sprintf('z: %f',z));
x = zeros(n,1);
x(bix) = xB;
disp(sprintf('sum(x-xcheat): %f',sum(x-xcheat)));
disp(sprintf('z-zcheat: %f',z-zcheat));

