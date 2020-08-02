     function database = build_database_src(rt_data_dir,suffix)  
      
    fprintf('dir the database');  
    subfolders = dir(rt_data_dir);  
      
    database = [];  
      
    database.imnum = 0;  
    database.cname = {};  
    database.label = [];  
    database.path = [];  
    database.nclass = 0;  
    label = 0;  
      
    k = 1;  
    src_x = [];  
    src_y = [];  
      
    for ii = 1 : length(subfolders)  
        subname = subfolders(ii).name;  
          
        if ~strcmp(subname,'.') && ~strcmp(subname,'..')  
              
            database.nclass = database.nclass + 1;  
            database.cname{database.nclass} = subname;  
              
            frames = dir(fullfile(rt_data_dir,subname,suffix));  
            c_num = length(frames);  
              
            database.imnum = database.imnum + c_num;  
            database.label = [database.label;ones(c_num,1) * database.nclass];  
              
            label = numel(database.cname);  
              
            for jj = 1 : c_num  
                fprintf('folder : %d , num : %d \n',ii - 1,jj);  
                  
                kk1 = frames(jj).name;%��ʾ����ͼƬ��;  
                c_path = fullfile(rt_data_dir,subname,frames(jj).name);  
                database.path = [database.path,c_path];  
                img = imread(database.path);%��ȡͼƬ;  
                im = imresize(img,[34,16]);%����ͼƬ��С;  
                  
                if(length(size(im)) == 3)%����ǲ�ɫͼ���лҶȻ�(���ݸ�����Ҫ);  
                    gray = rgb2gray(im);  
                else  
                    gray = im;  
                end  
                  
%                 gray = double(gray) / 255;%��ͼƬ��������һ��(���ݸ�����Ҫ);  
%                 database.path = [];  
                  
                src_x(:,:,k) = gray;%�洢ͼ������;  
                src_y(1,k) = label;%�����ݼӱ�ǩ;  
                k = k + 1;  
            end  
        end  
          
    end  
      
    %����ת���õ�.mat�ļ�;  
    file = ['src_x.mat'];  
    save(file,'src_x','-mat');  
    file = ['src_y.mat'];  
    save(file,'src_y','-mat');  
      
    end  