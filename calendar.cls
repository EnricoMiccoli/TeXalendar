\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{calendar}
[2018/09/07 v1.0]
\LoadClass[a5paper,12pt]{article}

% Packages
\RequirePackage[
    landscape,
    bottom=4mm,
    top=4mm,
    left=0mm,
    right=0mm
    ]{geometry}
\RequirePackage{array}
\RequirePackage{graphicx}
\RequirePackage{multirow}
\RequirePackage{xifthen}
\RequirePackage{keyval}
\RequirePackage{xcolor}
\RequirePackage{calc}

%%
%% DOCUMENT
%%
% Pagestyle
\pagenumbering{gobble}

%%
%% WEEKPAGE 
%%
% Localisation
\input{localisation.tex}

%% Weekpage dimensioning and styling
\newcommand{\wkmnthwdth}{5mm}
\newcommand{\wkrxwdth}{98mm}
% this ensures simmetry about the fold:
\newcommand{\wklxwdth}{\wkrxwdth - \wkmnthwdth}
% three rules per day:
\newcommand{\wkrowh}{\textheight / 21}
\setlength{\arrayrulewidth}{0.1mm}

\newcommand{\weekdayfont}{\footnotesize\textcolor{black}}
\newcommand{\numdayfont}{\Large\textcolor{rgray}}
\newcommand{\monthfont}{\footnotesize\scshape\color{rgray}}
% must use \color instead of \textcolor for monthfont
% [no known reason]
\definecolor{rulegray}{cmyk}{0,0,0,0.5}
\definecolor{rgray}{cmyk}{0,0,0,0.5}

% Keys and defaults
\define@key{week}{da}{\def\nda{#1}}
\define@key{week}{db}{\def\ndb{#1}}
\define@key{week}{dc}{\def\ndc{#1}}
\define@key{week}{dd}{\def\ndd{#1}}
\define@key{week}{de}{\def\nde{#1}}
\define@key{week}{df}{\def\ndf{#1}}
\define@key{week}{dg}{\def\ndg{#1}}
\define@key{week}{curmonth}{\def\ncmonth{#1}}
\define@key{week}{newmonth}{\def\nnmonth{#1}}
\define@key{week}{newday}{\def\nnday{#1}}
\setkeys{week}{
    da=00,db=00,dc=00,dd=00,de=00,df=00,dg=00,
    curmonth=default,
    newmonth=default,newday=3
}

% Weekpage auxiliaries
\newcommand{\wkmultirow}[1]{
    \multirow[c]{3}{*}{
        \rotatebox[origin=c]{90}{\monthfont #1}
    }
}

\newcommand{\wkday}[3]{
	% 1 day of the week
	% 2 number of the day
	% 3 month side label
    \wkmultirow{#3} & {\weekdayfont #1} & \\ \cline{3-3}
    & \numdayfont{#2} & \\\cline{3-3}
    & & \\\cline{3-3}
    \cline{2-3}
}

\newcommand{\daymonth}[3]{\ifthenelse{\equal{#1}{#2}}{#3}{}}

\newcommand\week{
    \color{rulegray}
    % mind the invisible rule used to set row height!
    \begin{tabular}{p{\wkmnthwdth}@{}p{\wklxwdth}@{\vline}p{\wkrxwdth}<{\rule[-2mm]{0pt}{\wkrowh}}}
    \cline{2-3}
    %\wkday{\wkdaya}{\nda}{\ncmonth}
    \wkday{\wkdaya}{\nda}{\daymonth{1}{1}{\ncmonth}}
    \wkday{\wkdayb}{\ndb}{\daymonth{\nnday}{2}{\nnmonth}}
    \wkday{\wkdayc}{\ndc}{\daymonth{\nnday}{3}{\nnmonth}}
    \wkday{\wkdayd}{\ndd}{\daymonth{\nnday}{4}{\nnmonth}}
    \wkday{\wkdaye}{\nde}{\daymonth{\nnday}{5}{\nnmonth}}
    \wkday{\wkdayf}{\ndf}{\daymonth{\nnday}{6}{\nnmonth}}
    \wkday{\wkdayg}{\ndg}{\daymonth{\nnday}{7}{\nnmonth}}
    \end{tabular}
}

% Weekpage
\newcommand\weekpage[1]{%
	\setkeys{week}{#1}
    \begin{center}
		\week
    \end{center}
    \pagebreak
}

%%
%% TIMETABLE
%%
\newcommand{\tttitle}[1]{
    {\Large\scshape\textcolor{rgray}{#1}}
}

\newcommand{\timefont}[1]{
    \textcolor{black}{#1}
}

\newcommand{\ttdayfont}[1]{
    \textcolor{black}{#1}
}

\newcommand{\ttweekdays}{
    \ttdayfont{\wkdaya} &
    \ttdayfont{\wkdayb} &
    \ttdayfont{\wkdayc} &
    \ttdayfont{\wkdayd} &
    \ttdayfont{\wkdaye} &
    \ttdayfont{\wkdayf}
}

\newcommand{\ttcolwdth}{25mm}
\newcommand{\tttimewdth}{10mm}
\newcommand{\ttrowh}{5mm}

% https://tex.stackexchange.com/a/12712
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

\newcommand{\timetable}[1]{
    \noindent\rule{5mm}{0pt}\tttitle{#1}
    \hfill\tttitle{#1}\rule{5mm}{0pt}    
    \begin{center}
    \color{rgray!60}

    \medskip

    \begin{tabular}{
        R{\tttimewdth} 
        |C{\ttcolwdth}<{\rule[-2mm]{0pt}{\ttrowh}}
        |C{\ttcolwdth}
        |C{\ttcolwdth}
        |C{\ttcolwdth}
        |C{\ttcolwdth}
        |C{\ttcolwdth}
        |L{\tttimewdth} 
    }
        & \ttweekdays \\\hline
        \timefont{08:15} & & & & & & & \timefont{08:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{09:15} & & & & & & & \timefont{09:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{10:15} & & & & & & & \timefont{10:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{11:15} & & & & & & & \timefont{11:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{12:15} & & & & & & & \timefont{12:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{13:15} & & & & & & & \timefont{13:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{14:15} & & & & & & & \timefont{14:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{15:15} & & & & & & & \timefont{15:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{16:15} & & & & & & & \timefont{16:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{17:15} & & & & & & & \timefont{17:15} \\\cline{2-7}
        & & & & & &  \\\hline
        \timefont{18:15} & & & & & & & \timefont{18:15} \\\cline{2-7}
        & & & & & &  \\\hline
    \end{tabular}
    \end{center}
    \vfill
    \pagebreak
}
