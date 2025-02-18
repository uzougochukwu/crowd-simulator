

%define PROT_READ	0x1		
%define PROT_WRITE	0x2		
%define PROT_EXEC	0x4		
%define PROT_NONE	0x0		
%define PROT_GROWSDOWN	0x01000000	
%define PROT_GROWSUP	0x02000000

%define MAP_SHARED	0x01		
%define MAP_PRIVATE	0x02		
%define MAP_SHARED_VALIDATE	0x03
%define MAP_TYPE	0x0f


%define MAP_FIXED	0x10	
%define MAP_FILE	0
%ifdef __MAP_ANONYMOUS
% define MAP_ANONYMOUS	__MAP_ANONYMOUS	
%else
%define MAP_ANONYMOUS	0x20		
%endif
%define MAP_ANON	MAP_ANONYMOUS
