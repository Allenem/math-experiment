%ѡȡ�ļ��У���ʼ��ʱ
DataSetName = 'Yale_32x32';tic;

%ѡȡStTrainFile2��ѵ�����ݣ����ļ���ÿ����10��ͼƬ�������ļ���������ı�X�㷨
train_data = dlmread(['.\txt��ʽ����\' DataSetName '\StTrainFile',num2str(2),'.txt']); %StTestFile2:150*1025,���һ�������
figure('NumberTitle', 'off', 'Name', 'ѵ��ͼ��'); %��figure����
X=cell(15,1); %ѵ������X������15x1ѵ�����飬ÿ����Ϊ1024x10�ľ��󣬽�ѵ��ԭ����ָ�
for i=10:10:150
    k=i/10;
    X{k}=[X{k},train_data(i-9:i,1:end-1)']; %��k���˵�1024x10�ľ���ѵ������
    A = train_data(i,1:end-1); %ѡÿ���˵����һ��ͼƬ������ʾ
    B_image = reshape(A,32,32); %��ͼƬ��32x32���ظ�ֵ��B_image
    subplot(3,5,k); %��3��5����ʾͼƬ
    imshow(B_image,[]); %��ͼƬB_image��ʾ
    title(['��' num2str(k) '��']);
end

%ѡȡStTestFile3���������ݣ����ļ���ÿ����1��ͼƬ�������ļ���������ı�Y��׼ȷ���㷨
test_data = dlmread(['.\txt��ʽ����\' DataSetName '\StTestFile',num2str(3),'.txt']); %StTestFile2:15*1025,���һ�������
figure('NumberTitle', 'off', 'Name', '����ͼ��');
Y=cell(15,1); %��������Y������15x1�������飬ÿ����Ϊ1024x10�ľ��󣬽�����ԭ����ָ�
beta=cell(15,15); %���Ž�beta
y=cell(15,15); %Ԥ��ֵy
d=[]; %ԭʼֵ������Ԥ��ֵ����֮�����
accuracy_num=0; %ʶ����ȷ������
for j=1:15
    Y{j}=[Y{j},test_data(j,1:end-1)']; %��j���˵�1024x10�ľ����������
    for p=1:15 
        beta{j,p}=inv(X{p}'*X{p})*X{p}'*Y{j}; %����ÿ��ѵ�������µĶ�Ӧ��j���������ݵ����Ž�
        y{j,p}=X{p}*beta{j,p}; %����Ԥ��ֵ
        d(p)=dot(Y{j}-y{j,p},Y{j}-y{j,p}); %����ԭʼֵ������Ԥ��ֵ����֮�����
    end
    clear min;
    [m, n]=min(d); %mΪd��Сֵ��nΪ�±꼴��n��ѵ��������ӽ���j�ݲ�������
    if n==j
        accuracy_num=accuracy_num+1; %������ȷ��
    end
    C = test_data(j,1:end-1);
    D_image = reshape(C,32,32);
    subplot(3,5,j)
    imshow(D_image,[]) %��ʾÿ�ݲ�������ͼ��
    title(['ʶ����ǵ�' num2str(n) '��']); %��ʾʶ������������Ӧ��ѵ�������е��ĸ���
end
accuracy=accuracy_num/15;
time=toc; %��ʱ����
suptitle(['���㷨��StTestFile3�ļ�������ʶ��׼ȷ��Ϊ��',num2str(accuracy*100),'%' ,' ����ʱ�䣺',num2str(time),'s']); %��ʾʶ��׼ȷ�ʺ�����ʱ��
